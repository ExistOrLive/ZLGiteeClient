//
//  ZLWorkBoardController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLBaseUI

class ZLWorkBoardController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工作台"
        
        let button = UIButton(type: .custom)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func onButtonClicked() {
//        let vc = ZLRepoInfoController(repoFullName: "existorlive/GithubClient")
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        oauthManager.startOAuth(type: .code,
                                delegate: self) { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.viewController?.present(vc, animated: true, completion: nil)
        }
    }

    lazy var oauthManager: ZLGiteeOAuthManager = {
        let manager = ZLGiteeOAuthManager(client_id: GiteeClientID,
                                          client_secret: GiteeClientSecret,
                                          redirect_uri: GiteeRedirectURL)
        return manager
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ZLWorkBoardController: ZLGiteeOAuthManagerDelegate {
    
    func onOAuthStatusChanged(status: ZLGiteeOAuthStatus) {
        
    }
    
    func onOAuthSuccess(access_token: String,refresh_token: String) {
        
    }
    
    func onOAuthFail(status: ZLGiteeOAuthStatus, error: String) {
        print("dasdasdas \(error)")
    }
}
