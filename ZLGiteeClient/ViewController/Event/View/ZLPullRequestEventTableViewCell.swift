//
//  ZLPullRequstTableViewCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/27.
//

import Foundation
import UIKit
import ZLBaseExtension
import ZLUtilities
import ZLUIUtilities
import YYText

/// PullRequestEvent, PullRequestCommentEvent
protocol ZLPullRequstEventTableViewCellDelegate: AnyObject {
    func pullRequestNumber() -> String
    func pullRequestState() -> String
    func pullRequesTitle() -> String
    func pullRequestBase() -> String
    func pullRequestHead() -> String
    
    func onPullRequestBaseRepoClicked()
    func onPullRequestHeadRepoClicked()
}

class ZLPullRequestEventTableViewCell: ZLEventTableViewCell {
    
    weak var eventDelegate: ZLPullRequstEventTableViewCellDelegate? {
        delegate as? ZLPullRequstEventTableViewCellDelegate
    }
    
    override func setUpUI() {
        super.setUpUI()
        assistInfoView.borderWidth = 0.3
        assistInfoView.borderColor = .gray
        assistInfoView.cornerRadius = 2.0
        assistInfoView.addSubview(pullRequestStackView)
        assistInfoView.addSubview(pullRequestIcon)
        
        pullRequestIcon.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.size.equalTo(22)
        }
        pullRequestStackView.snp.makeConstraints { make in
            make.left.equalTo(pullRequestIcon.snp.right).offset(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var pullRequestStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.addArrangedSubview(pullRequestTitle)
        view.addArrangedSubview(pullRequestScollView)
        pullRequestScollView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        return view
    }()
    
    lazy var pullRequestIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage.iconFontImage(withText: "\u{e798}",
                                                fontSize: 20,
                                                color: UIColor.iconColor(withName: "ICON_Common"))
        return imageView
    }()
    
    lazy var pullRequestTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = .label(withName: "ZLLabelColor1")
        return label
    }()
        
    lazy var pullRequestScollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(headButton)
        scrollView.addSubview(arrowImageView)
        scrollView.addSubview(baseButton)
        headButton.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.left.equalTo(headButton.snp.right).offset(4)
            make.size.equalTo(15)
            make.centerY.equalTo(headButton)
        }
        
        baseButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.height.equalTo(20)
            make.left.equalTo(arrowImageView.snp.right).offset(4)
        }
        
        return scrollView
    }()

    lazy var headButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.addSubview(headLabel)
        button.addTarget(self, action: #selector(onHeadRepoClicked), for: .touchUpInside)
        headLabel.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.right.equalTo(-4)
            make.centerY.equalToSuperview()
        }
        return button
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage.iconFontImage(withText: "\u{e66c}",
                                                fontSize: 15,
                                                color: .lightGray)
        return imageView
    }()
    
    lazy var headLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 10)
        label.textColor = .label(withName: "ZLLabelColor4")
        return label
    }()
    
    lazy var baseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.addSubview(baseLabel)
        button.addTarget(self, action: #selector(onBaseRepoClicked), for: .touchUpInside)
        baseLabel.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.right.equalTo(-4)
            make.centerY.equalToSuperview()
        }
        return button
    }()
    
    lazy var baseLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 10)
        label.textColor = .label(withName: "ZLLabelColor4")
        return label
    }()

    
    override func fillWithViewData(viewData: ZLEventTableViewCellData) {
        super.fillWithViewData(viewData: viewData)
        guard let cellData = viewData as? ZLPullRequstEventTableViewCellDelegate else {
            return
        }
        pullRequestTitle.text = "#\(cellData.pullRequestNumber()) \(cellData.pullRequesTitle())"
        headLabel.text = cellData.pullRequestHead()
        baseLabel.text = cellData.pullRequestBase()
        
    }
}

extension ZLPullRequestEventTableViewCell {
    @objc dynamic func onBaseRepoClicked() {
        eventDelegate?.onPullRequestBaseRepoClicked()
    }
    
    @objc dynamic func onHeadRepoClicked() {
        eventDelegate?.onPullRequestHeadRepoClicked()
    }
}


