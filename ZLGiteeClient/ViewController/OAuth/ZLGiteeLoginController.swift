//
//  ZLGiteeLoginController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/12.
//

import Foundation
import ZLUIUtilities

enum ZLLoginStep {
    case initialize
    case oauth
    case gettoken
    case checktoken
    
    var eventTrack: Int {
        switch self {
        case .initialize:
            return 0
        case .oauth:
            return 1
        case .gettoken:
            return 2
        case .checktoken:
            return 3
        }
    }
}

class ZLGiteeLoginController: ZMViewController {
        
    // 登陆操作的流水号
    private var loginSerialNumber: String?
    // 登陆步骤
    private var step: ZLLoginStep = .initialize
    
    /// datetime
    private var startTime: TimeInterval = 0
    private var endTime: TimeInterval = 0
    
    /// oauth manager
    lazy var oauthManager: ZLGiteeOAuthManager = {
        let manager = ZLGiteeOAuthManager(client_id: GiteeClientID,
                                          client_secret: GiteeClientSecret,
                                          redirect_uri: GiteeRedirectURL)
        return manager
    }()
        
    override func setupUI() {
        super.setupUI()
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(loginInfoLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(accessTokenButton)
        
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        loginInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(45)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.left.equalTo(loginInfoLabel.snp.right).offset(10)
        }
        
        accessTokenButton.snp.makeConstraints { make in
            make.right.equalTo(-40)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(33)
        }
    }
    
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.cornerRadius = 5.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ZLGiteeClient"
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = UIFont.zlMediumFont(withSize: 30)
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.color = UIColor(named:"ZLLabelColor2")
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    lazy var loginInfoLabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = UIFont.zlRegularFont(withSize: 12)
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let button = ZMButton()
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        button.setTitle("登录", for: .normal)
        button.addTarget(self, action: #selector(onLoginButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var accessTokenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named:"ZLLinkLabelColor1"), for: .normal)
        button.setTitle("Access Token", for: .normal)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 15)
        button.addTarget(self, action: #selector(onAccessTokenButtonClicked), for: .touchUpInside)
        return button
    }()
    
    func reloadView() {
        switch step {
        case .initialize:
            loginButton.isEnabled = true
            accessTokenButton.isEnabled = true
            loginInfoLabel.text = nil
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        case .oauth:
            loginButton.isEnabled = false
            accessTokenButton.isEnabled = false
            loginInfoLabel.text = "登录中..."
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        case .gettoken:
            loginButton.isEnabled = false
            accessTokenButton.isEnabled = false
            loginInfoLabel.text = "正在获取token...."
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        case .checktoken:
            loginButton.isEnabled = false
            accessTokenButton.isEnabled = false
            loginInfoLabel.text = "检查token是否有效..."
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}

// MARK: - Action
extension ZLGiteeLoginController {
    @objc func onLoginButtonClicked() {
        
        startTime = Date().timeIntervalSince1970
        oauthManager.startOAuth(type: .code,
                                delegate: self) { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
    }

    @objc func onAccessTokenButtonClicked() {
        ZLInputAccessTokenView.showInputAccessTokenView(resultBlock: {[weak self] (token: String?) in
            guard let self, let token, !token.isEmpty else {
                ZLToastView.showMessage("请输入token")
                return
            }
            
            ZLGiteeOAuthUserServiceModel.sharedService.checkToken(access_token: token,
                                                                  refresh_token: "") { [weak self] result, msg in
                guard let self else { return }
                self.step = .initialize
                self.reloadView()
                if result {
                    ZLToastView.showMessage("登录成功")
                } else {
                    ZLToastView.showMessage(msg)
                }
            }
            
            self.step = .checktoken
            self.reloadView()
        })
    }
}

// MARK: - ZLGiteeOAuthManagerDelegate
extension ZLGiteeLoginController: ZLGiteeOAuthManagerDelegate {
    
    func onOAuthStatusChanged(status: ZLGiteeOAuthStatus, serialNumber: String) {
        switch status {
        case .initialized:
            break
        case .authorize:
            step = .oauth
            reloadView()
        case .getToken:
            step = .gettoken
            reloadView()
            break
        case .fail:
            break
        case .success:
            break
        }
    }
    
    func onOAuthSuccess(access_token: String, refresh_token: String, serialNumber: String) {
        endTime = Date().timeIntervalSince1970
        oauthManager.reset()
        step = .checktoken
        reloadView()
        
        ZLGiteeOAuthUserServiceModel.sharedService.checkToken(access_token: access_token,
                                                   refresh_token: refresh_token) { [weak self] result, msg in
            guard let self else { return }
            self.step = .initialize
            self.reloadView()
            if result {
                ZLToastView.showMessage("登录成功")
            } else {
                ZLToastView.showMessage(msg)
            }
        }
    }
    
    func onOAuthFail(status: ZLGiteeOAuthStatus, error: String, serialNumber: String) {
        endTime = Date().timeIntervalSince1970
        oauthManager.reset()
        step = .initialize
        reloadView()
        ZLToastView.showMessage(error)
    }
}
