//
//  ZLRepoEventTableViewCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/20.
//

import Foundation
import UIKit
import ZLBaseExtension
import ZLUtilities
import ZLUIUtilities

/// StarEvent, ForkEvent

protocol ZLRepoEventTableViewCellDelegate: AnyObject {
    func repoName() -> String
    func sourceRepoName() -> String
    func onSourceRepoButtonClicked()
}
extension ZLRepoEventTableViewCellDelegate {
    func onSourceRepoButtonClicked() { }
    func sourceRepoName() -> String { "" }
}


class ZLRepoEventTableViewCell: ZLEventTableViewCell {
    
    weak var eventDelegate: ZLRepoEventTableViewCellDelegate? {
        delegate as? ZLRepoEventTableViewCellDelegate
    }
    
    override func setUpUI() {
        super.setUpUI()
        assistInfoView.borderWidth = 0.3
        assistInfoView.borderColor = .gray
        assistInfoView.cornerRadius = 2.0
        assistInfoView.addSubview(repoIcon)
        assistInfoView.addSubview(repoStackView)
        
        repoIcon.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.size.equalTo(22)
        }
        repoStackView.snp.makeConstraints { make in
            make.left.equalTo(repoIcon.snp.right).offset(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var repoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.addArrangedSubview(repoName)
        view.addArrangedSubview(sourceRepoView)
        return view
    }()
    
    lazy var repoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage.iconFontImage(withText: "\u{e6f3}",
                                                fontSize: 20,
                                                color: UIColor.iconColor(withName: "ICON_Common"))
        return imageView
    }()
    
    lazy var repoName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label(withName: "ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 16)
        label.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        return label
    }()
    
    lazy var sourceRepoView: UIView = {
        let view = UIView()
        view.addSubview(forkLabel)
        view.addSubview(sourceRepoNameButton)
        forkLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        sourceRepoNameButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(forkLabel.snp.right)
        }
        return view
    }()
    
    lazy var forkLabel: UILabel = {
        let label = UILabel()
        let labelColor = (getRealUserInterfaceStyle() == .light) ? ZLRGBValue_H(colorValue: 0x666666) : ZLRGBValue_H(colorValue: 0x999999)
        label.textColor = labelColor
        label.font = .zlMediumFont(withSize: 13)
        label.text = "forked from "
        return label
    }()
    
    lazy var sourceRepoNameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .zlMediumFont(withSize: 13)
        button.setTitleColor(UIColor.label(withName: "ZLLinkLabelColor1"), for: .normal)
        button.addTarget(self, action: #selector(onSourceRepoButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func zm_fillWithViewData(viewData: ZLEventTableViewCellData) {
        super.zm_fillWithViewData(viewData: viewData)
        guard let cellData = viewData as? ZLRepoEventTableViewCellDelegate else {
            return
        }
        repoName.text = cellData.repoName()
        sourceRepoView.isHidden = cellData.sourceRepoName().isEmpty
        sourceRepoNameButton.setTitle(cellData.sourceRepoName(), for: .normal)
    }
}

// MARK: - Action
extension ZLRepoEventTableViewCell {
    
    @objc dynamic func onSourceRepoButtonClicked() {
        eventDelegate?.onSourceRepoButtonClicked()
    }
}

