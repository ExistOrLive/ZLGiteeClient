//
//  ZLCommitCommentEventTableViewCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/28.
//

import Foundation
import UIKit
import ZLBaseExtension
import ZLUtilities
import ZLUIUtilities
import YYText

// CommitCommentEvent
class ZLCommitCommentEventTableViewCell: ZLEventTableViewCell {
    
    weak var eventDelegate: ZLCommitCommentEventTableViewCellData? {
        delegate as? ZLCommitCommentEventTableViewCellData
    }
 
    override func setUpUI() {
        super.setUpUI()
        assistInfoView.borderWidth = 0.3
        assistInfoView.borderColor = .gray
        assistInfoView.cornerRadius = 2.0
        assistInfoView.addSubview(commitStackView)
        assistInfoView.addSubview(commitIcon)
        
        commitIcon.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.size.equalTo(22)
        }
        commitStackView.snp.makeConstraints { make in
            make.left.equalTo(commitIcon.snp.right).offset(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var commitStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.addArrangedSubview(commitLabel)
        view.addArrangedSubview(repoNameButton)
        return view
    }()
    
    lazy var commitIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage.iconFontImage(withText: "\u{e857}",
                                                fontSize: 20,
                                                color: UIColor.iconColor(withName: "ICON_Common"))
        return imageView
    }()
    
    lazy var commitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label(withName: "ZLLinkLabelColor2")
        label.font = .zlMediumFont(withSize: 15)
        return label
    }()
        
    lazy var repoNameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label(withName: "ZLLabelColor2"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 15)
        button.addTarget(self, action: #selector(onRepoButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func fillWithViewData(viewData: ZLEventTableViewCellData) {
        super.fillWithViewData(viewData: viewData)
        guard let cellData = viewData as? ZLCommitCommentEventTableViewCellData else {
            return
        }
        commitLabel.text = cellData.commit_id()
        repoNameButton.setTitle(cellData.repoHumanName(), for: .normal)
    }
}

extension ZLCommitCommentEventTableViewCell {
    @objc dynamic func onRepoButtonClicked() {
        eventDelegate?.onRepoButtonClicked()
    }
}


