//
//  ZLWorkBoardHeaderCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/7/17.
//

import Foundation
import UIKit
import ZLBaseExtension
import SnapKit
import ZLUIUtilities
import ZMMVVM

// MARK: - ZLWorkboardButtonType
enum ZLWorkboardButtonType: Int {
    case repos                // 仓库
    case pullRequest          // Pull Requests
    case issues               // Issues
    case starRepos            // 星选集
    case gists                // 代码片段

    case orgs                 // 组织
    case companys             // 企业
    
    var title: String {
        switch self {
        case .repos:
            return "仓库"
        case .pullRequest:
            return "Pull Request"
        case .issues:
            return "Issue"
        case .gists:
            return "代码片段"
        case .starRepos:
            return "星选集"
        case .orgs:
            return "组织"
        case .companys:
            return "企业"
        }
    }
    
    var icon: UIImage? {
        var imageName: String = ""
        switch self {
        case .repos:
            imageName = "workboard_repo"
        case .pullRequest:
            imageName = "workboard_pr"
        case .issues:
            imageName = "workboard_issue"
        case .gists:
            imageName = "workboard_gist"
        case .starRepos:
            imageName = "workboard_star"
        case .orgs:
            imageName = "workboard_org"
        case .companys:
            imageName = "workboard_company"
        }
        return UIImage(named: imageName)
    }
}

// MARK: - ZLWorkBoardHeaderCellData
class ZLWorkBoardHeaderCellData: ZMBaseTableViewCellViewModel {
        
    let stateModel: ZLWorkBoardStateModel
    
    init(stateModel: ZLWorkBoardStateModel) {
        self.stateModel = stateModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLWorkBoardHeaderCell"
    }
    
    var login: String {
        stateModel.userModel?.login ?? ""
    }
    
    var name: String {
        stateModel.userModel?.name ?? ""
    }
    
    var avatar_url: String {
        stateModel.userModel?.avatar_url ?? ""
    }
    
    func onButtonClicked(type: ZLWorkboardButtonType) {
        switch type {
        case .repos:
            let vc = ZLMyRepoListController()
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        case .pullRequest:
            break
        case .issues:
            break
        case .starRepos:
            let vc = ZLUserStarsListController()
            vc.login = login
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        case .gists:
            break
        default:
            break
        }
    }
    
    func onAvatarButtonClicked() {
        let vc = ZLUserInfoController(login: login)
        vc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ZLWorkBoardHeaderCell
class ZLWorkBoardHeaderCell: UITableViewCell {
    
    var cellData: ZLWorkBoardHeaderCellData? {
        zm_viewModel as? ZLWorkBoardHeaderCellData
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(backImageView)
        contentView.addSubview(infoView)
        contentView.addSubview(buttonStackView)
        
        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
            make.top.equalTo(ZLStatusBarHeight)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(infoView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        let buttonTypeArray: [ZLWorkboardButtonType] = [.repos,.pullRequest,.issues,.starRepos,.gists]
        buttonTypeArray.forEach { type in
            let button = ZLWorkBoardButton()
            button.icon.image = type.icon
            button.buttonLabel.text = type.title
            button.tag = type.rawValue
            button.addTarget(self, action: #selector(onWorkBoardButtonClicked(button:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.size.equalTo(60)
            }
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    // infoView
    lazy var infoView: UIView = {
        let view = UIView()
        view.addSubview(avatarButton)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(logoImageView)
        
        avatarButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.size.equalTo(CGSize(width: 52, height: 52))
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarButton)
            make.left.equalTo(avatarButton.snp.right).offset(20)
        }
        loginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatarButton)
            make.left.equalTo(avatarButton.snp.right).offset(20)
        }
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.size.equalTo(55)
        }
        return view
    }()
    
    lazy var avatarButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        button.circle = true
        button.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 18)
        label.textColor = UIColor(hexString: "FFFFFF")
        return label
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 14)
        label.textColor = UIColor(hexString: "D9D4D4")
        return label
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "g_logo")
        return imageView
    }()
    
    // backImageView
    lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "workboard_background")
        return imageView
    }()
    
    // buttonStackView
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
}

extension ZLWorkBoardHeaderCell {
    @objc func onWorkBoardButtonClicked(button: UIButton) {
        guard let type = ZLWorkboardButtonType(rawValue: button.tag) else { return }
        cellData?.onButtonClicked(type: type)
    }
    
    @objc func onAvatarButtonClicked() {
        cellData?.onAvatarButtonClicked()
    }
}


extension  ZLWorkBoardHeaderCell:  ZMBaseViewUpdatableWithViewData {
     func zm_fillWithViewData(viewData: ZLWorkBoardHeaderCellData) {
       nameLabel.text = viewData.name
        loginLabel.text = viewData.login
        avatarButton.sd_setBackgroundImage(with: URL(string: viewData.avatar_url),
                                           for: .normal,
                                           placeholderImage: UIImage(named: "default_avatar"))
     }
}

// MARK: - ZLWorkBoardButton
class ZLWorkBoardButton: UIButton {
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 13)
        label.textColor = .white
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(icon)
        addSubview(buttonLabel)
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        buttonLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
}
