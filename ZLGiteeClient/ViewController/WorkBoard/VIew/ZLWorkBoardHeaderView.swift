//
//  ZLWorkBoardView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/14.
//

import Foundation
import ZLBaseUI
import ZLUIUtilities
import ZLUtilities

class ZLWorkBoardHeaderViewData: ZLBaseViewModel {
    
    let height: CGFloat = 450
    
    let model: ZLGiteeUserBriefModel
    
    init(model: ZLGiteeUserBriefModel) {
        self.model = model
        super.init()
    }
    
    func onRepoButtonClicked() {
        let vc = ZLMyRepoListController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onOrgButtonClicked() {
        let vc = ZLMyOrgListController()
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class ZLWorkBoardHeaderView: UIView {
    
    weak var delegate: ZLWorkBoardHeaderViewData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(named: "ZLVCBackColor")
        addSubview(stackView)
        
        stackView.addArrangedSubview(baseInfoView)
    
        stackView.addArrangedSubview(repoItemView)
        stackView.addArrangedSubview(orgItemView)
        stackView.addArrangedSubview(companyItemView)
        
        stackView.addArrangedSubview(contributionContainerView)
        
        stackView.setCustomSpacing(10, after: baseInfoView)
        stackView.setCustomSpacing(10, after: companyItemView)
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        repoItemView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        orgItemView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        companyItemView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var baseInfoView: ZLWorkBoardBaseInfoView = {
       let view = ZLWorkBoardBaseInfoView()
        return view
    }()
    
    lazy var repoItemView: ZLWorkBoardBaseItemView = {
        let view = ZLWorkBoardBaseItemView()
        view.titleLabel.text = "仓库"
        view.avatarImageView.image = UIImage.iconFontImage(withText: "\u{e74f}", fontSize: 20 , imageSize: CGSize(width: 30, height: 30), color: .iconColor(withName: "ZLLabelColor1"))
        view.clickBlock = { [weak self] in
            self?.delegate?.onRepoButtonClicked()
        }
        return view
    }()
    
    lazy var orgItemView: ZLWorkBoardBaseItemView = {
        let view = ZLWorkBoardBaseItemView()
        view.titleLabel.text = "组织"
        view.avatarImageView.image = UIImage.iconFontImage(withText: "\u{e6dd}", fontSize: 20 , imageSize: CGSize(width: 30, height: 30), color: .iconColor(withName: "ZLLabelColor1"))
        view.clickBlock = { [weak self] in
            self?.delegate?.onOrgButtonClicked()
        }
        return view
    }()
    
    lazy var companyItemView: ZLWorkBoardBaseItemView = {
        let view = ZLWorkBoardBaseItemView()
        view.titleLabel.text = "企业"
        view.avatarImageView.image = UIImage.iconFontImage(withText: "\u{e61f}", fontSize: 20 , imageSize: CGSize(width: 30, height: 30), color: .iconColor(withName: "ZLLabelColor1"))
        return view
    }()
    
    lazy var contributionContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.addSubview(contributionLabel)
        
        view.addSubview(contributionView)
        
        contributionLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        
        contributionView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
            make.bottom.equalTo(-10)
            make.height.equalTo(100)
        }
        return view
    }()
        
    lazy var contributionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 16)
        label.text = "贡献度"
        return label
    }()
    
    lazy var contributionView: ZLGiteeContributionsView = {
       let view = ZLGiteeContributionsView()
        return view
    }()
    
}

extension ZLWorkBoardHeaderView: ZLViewUpdatableWithViewData {
    func justUpdateView() {
        
    }
    
    func fillWithViewData(viewData: ZLWorkBoardHeaderViewData) {
        let model = viewData.model
        baseInfoView.imageView.sd_setImage(with: URL(string: model.avatar_url ?? ""), placeholderImage: UIImage(named: "default_avatar"))
        baseInfoView.nameLabel.text = model.name
        baseInfoView.loginLabel.text = model.login
        contributionView.startLoad(loginName: model.login ?? "")
        
        delegate = viewData
    }
}
