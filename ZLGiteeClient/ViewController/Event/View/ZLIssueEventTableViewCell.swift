//
//  ZLIssueEventTableViewCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/22.
//

import Foundation
import UIKit
import ZLBaseExtension
import ZLUtilities
import ZLUIUtilities
import YYText

/// StarEvent, ForkEvent
protocol ZLIssueEventTableViewCellDelegate: AnyObject {
    func issueId() -> String
    func issueTitle() -> String
    func issueRepoHumanName() -> String
    func onIssueRepoClicked()
}

class ZLIssueEventTableViewCell: ZLEventTableViewCell {
    
    weak var eventDelegate: ZLIssueEventTableViewCellDelegate? {
        delegate as? ZLIssueEventTableViewCellDelegate
    }
    
    override func setUpUI() {
        super.setUpUI()
        assistInfoView.borderWidth = 0.3
        assistInfoView.borderColor = .gray
        assistInfoView.cornerRadius = 2.0
        assistInfoView.addSubview(issueStackView)
        assistInfoView.addSubview(issueIcon)
        
        issueIcon.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.size.equalTo(22)
        }
        issueStackView.snp.makeConstraints { make in
            make.left.equalTo(issueIcon.snp.right).offset(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var issueStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.addArrangedSubview(issueNumberButton)
        view.addArrangedSubview(issueTitleLabel)
        return view
    }()
    
    lazy var issueIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage.iconFontImage(withText: "\u{e70f}",
                                                fontSize: 20,
                                                color: UIColor.iconColor(withName: "ICON_Common"))
        return imageView
    }()
    
    lazy var issueNumberButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onIssueNumberButtonClicked), for: .touchUpInside)
        return button
    }()
        
    lazy var issueTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .label(withName: "ZLLabelColor2")
        label.font = .zlMediumFont(withSize: 11)
        return label
    }()
    

    
    override func fillWithViewData(viewData: ZLEventTableViewCellData) {
        super.fillWithViewData(viewData: viewData)
        guard let cellData = viewData as? ZLIssueEventTableViewCellDelegate else {
            return
        }
        let issueNumberStr = NSASCContainer(
            "#\(cellData.issueId())"
                .asMutableAttributedString()
                .font(.zlMediumFont(withSize: 16))
                .foregroundColor(.label(withName: "ZLLabelColor4")),
            " ",
            cellData.issueRepoHumanName()
        ).font(.zlMediumFont(withSize: 15))
            .foregroundColor(.label(withName: "ZLLabelColor1"))
            .asAttributedString()
        issueNumberButton.setAttributedTitle(issueNumberStr, for: .normal)
        issueTitleLabel.text = cellData.issueTitle()
    }
}

extension ZLIssueEventTableViewCell {
    @objc dynamic func onIssueNumberButtonClicked() {
        eventDelegate?.onIssueRepoClicked()
    }
}

