//
//  ZLWorkBoardView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/14.
//

import Foundation
import ZLBaseUI
import ZLUIUtilities


class ZLWorkBoardHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(named: "ZLCellBack")
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(loginLabel)
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.size.equalTo(50)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
        loginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
}

extension ZLWorkBoardHeaderView: ZLViewUpdatableWithViewData {
    func justUpdateView() {
        
    }
    
    func fillWithViewData(viewData: ZLGiteeUserBriefModel) {
        imageView.sd_setImage(with: URL(string: viewData.avatar_url ?? ""), placeholderImage: UIImage(named: "default_avatar"))
        nameLabel.text = viewData.name
        loginLabel.text = viewData.login
    }
}
