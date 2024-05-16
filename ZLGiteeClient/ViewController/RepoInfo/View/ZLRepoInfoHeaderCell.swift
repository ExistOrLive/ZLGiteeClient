//
//  ZLRepoInfoHeaderCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/6/3.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLBaseExtension
import YYText
import ZLUIUtilities
import SnapKit
import SDWebImage

protocol ZLRepoInfoHeaderCellDataSourceAndDelegate: NSObjectProtocol {
    
    var avatarUrl: String {get}
    var repoName: String {get}
    var repoHumanName: String {get}
    var sourceRepoName: String? {get}
    var sourceRepoHumanName: String? {get}
    var updatedTime: String {get}
    var desc: String {get}
    
    var issueNum: Int {get}
    var starsNum: Int {get}
    var forksNum: Int {get}
    var watchersNum: Int {get}
    
    var watched: Bool {get}
    var starred: Bool {get}
    
    func onAvatarButtonClicked()
    func onStarButtonClicked()
    func onForkButtonClicked()
    func onWatchButtonClicked()

    func onIssuesNumButtonClicked()
    func onStarsNumButtonClicked()
    func onForksNumButtonClicked()
    func onWatchersNumButtonClicked()
    
    func onSourceRepoClicked()
}


class ZLRepoInfoHeaderCell: UITableViewCell {

    weak var delegate: ZLRepoInfoHeaderCellDataSourceAndDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor(named: "ZLCellBack")

        addSubview(avatarButton)
        addSubview(nameLabel)
        addSubview(descLabel)
        addSubview(timeLabel)

        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(issuesNumButton)
        buttonStackView.addArrangedSubview(starsNumButton)
        buttonStackView.addArrangedSubview(forksNumButton)
        buttonStackView.addArrangedSubview(watchersNumButton)

        addSubview(buttonStackView1)
        buttonStackView1.addArrangedSubview(watchButton)
        buttonStackView1.addArrangedSubview(starButton)
        buttonStackView1.addArrangedSubview(forkButton)

        avatarButton.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(15)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(avatarButton.snp.bottom).offset(15)
        }
//        nameLabel.preferredMaxLayoutWidth = ZLScreenWidth - 60

        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
        }

        descLabel.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.left.equalTo(30)
            make.top.equalTo(timeLabel.snp.bottom).offset(25)
        }

        buttonStackView.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.bottom.equalTo(-10)
            make.height.equalTo(50)
        }

        buttonStackView1.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalTo(avatarButton)
        }

        watchButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 25))
        }
        
        starButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 25))
        }
        
        forkButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 25))
        }
    }
    
    
    // MARK: View
    private lazy var avatarButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.circle = true
        button.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)
        return button 
    }()
    
    private lazy var nameLabel: YYLabel = {
        let label = YYLabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont.zlMediumFont(withSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont.zlRegularFont(withSize: 11)
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.numberOfLines = 4
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 35
        return stackView
    }()

    private lazy var buttonStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var issuesNumButton: ZLRepoInfoHeaderButton = {
        let button = ZLRepoInfoHeaderButton()
        button.numLabel.text  = "0"
        button.nameLabel.text = "issues"
        button.addTarget(self, action: #selector(onIssuesNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var starsNumButton: ZLRepoInfoHeaderButton = {
        let button = ZLRepoInfoHeaderButton()
        button.numLabel.text  = "0"
        button.nameLabel.text = "stars"
        button.addTarget(self, action: #selector(onStarsNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var forksNumButton: ZLRepoInfoHeaderButton = {
        let button = ZLRepoInfoHeaderButton()
        button.numLabel.text  = "0"
        button.nameLabel.text = "forks"
        button.addTarget(self, action: #selector(onForksNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var watchersNumButton: ZLRepoInfoHeaderButton = {
        let button = ZLRepoInfoHeaderButton()
        button.numLabel.text  = "0"
        button.nameLabel.text = "watching"
        button.addTarget(self, action: #selector(onWatchersNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var watchButton: ZLBaseButton = {
        let button = ZLBaseButton()
        button.setTitle("Watch", for: .normal)
        button.setTitle("Watching", for: .selected)
        button.titleLabel?.font = UIFont.zlSemiBoldFont(withSize: 10)
        button.addTarget(self, action: #selector(onWatchButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var starButton: ZLBaseButton = {
        let button = ZLBaseButton()
        button.setTitle("Star", for: .normal)
        button.setTitle("Starred", for: .selected)
        button.titleLabel?.font = UIFont.zlSemiBoldFont(withSize: 10)
        button.addTarget(self, action: #selector(onStarButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var forkButton: ZLBaseButton = {
        let button = ZLBaseButton()
        button.setTitle("Fork", for: .normal)
        button.titleLabel?.font = UIFont.zlSemiBoldFont(withSize: 10)
        button.addTarget(self, action: #selector(onForkButtonClicked), for: .touchUpInside)
        return button
    }()

}

// MARK: Action
extension ZLRepoInfoHeaderCell {
    
    @objc func onAvatarButtonClicked() {
        delegate?.onAvatarButtonClicked()
    }
    
    @objc func onIssuesNumButtonClicked() {
        delegate?.onIssuesNumButtonClicked()
    }
    
    @objc func onStarsNumButtonClicked() {
        delegate?.onStarsNumButtonClicked()
    }
    
    @objc func onForksNumButtonClicked() {
        delegate?.onForksNumButtonClicked()
    }
    
    @objc func onWatchersNumButtonClicked() {
        delegate?.onWatchersNumButtonClicked()
    }
    
    @objc func onWatchButtonClicked() {
        delegate?.onWatchButtonClicked()
    }
    
    @objc func onStarButtonClicked() {
        delegate?.onStarButtonClicked()
    }
    
    @objc func onForkButtonClicked() {
        delegate?.onForkButtonClicked()
    }
}

// MARK: - ZLViewUpdatableWithViewData
extension ZLRepoInfoHeaderCell: ZLViewUpdatableWithViewData {
    
    func reloadData() {
        guard let data = delegate else { return }
        
        avatarButton.sd_setBackgroundImage(with: URL(string: data.avatarUrl), for: .normal, placeholderImage: UIImage(named: "default_avatar"))
        timeLabel.text = "\(data.updatedTime)"
        descLabel.text = data.desc
        
        issuesNumButton.numLabel.text = data.issueNum >= 1000 ? String(format: "%.1f", Double(data.issueNum) / 1000.0) + "k" : "\(data.issueNum)"
        starsNumButton.numLabel.text = data.starsNum >= 1000 ? String(format: "%.1f", Double(data.starsNum) / 1000.0) + "k" : "\(data.starsNum)"
        forksNumButton.numLabel.text = data.forksNum >= 1000 ? String(format: "%.1f", Double(data.forksNum) / 1000.0) + "k" : "\(data.forksNum)"
        watchersNumButton.numLabel.text = data.watchersNum >= 1000 ? String(format: "%.1f", Double(data.watchersNum) / 1000.0) + "k" : "\(data.watchersNum)"
        
        starButton.isSelected = data.starred
        watchButton.isSelected = data.watched
        

        let tmpColor1 = (getRealUserInterfaceStyle() == .light) ? ZLRGBValue_H(colorValue: 0x333333) : ZLRGBValue_H(colorValue: 0xCCCCCC)
        let tmpColor2 = (getRealUserInterfaceStyle() == .light) ? ZLRGBValue_H(colorValue: 0x666666) : ZLRGBValue_H(colorValue: 0x999999)
        
        if let sourceRepoHumanName = data.sourceRepoHumanName,
           !sourceRepoHumanName.isEmpty {

            let attributedStr = NSASCContainer(
                
                data.repoHumanName
                    .asMutableAttributedString()
                    .foregroundColor(tmpColor1)
                    .font(.zlMediumFont(withSize: 16)),
                
                "\nforked from "
                    .asMutableAttributedString()
                    .foregroundColor(tmpColor2)
                    .font(.zlMediumFont(withSize: 13)),
                
                sourceRepoHumanName
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 13))
                    .yy_highlight(ZLRawColor(name: "ZLLinkLabelColor1"),
                                  backgroudColor:  ZLRawColor(name: "ZLLinkLabelColor1"),
                                  tapAction: { [weak self] _, _, _, _ in
                                      self?.delegate?.onSourceRepoClicked()
                                  })
                
            ).asAttributedString()
        
            nameLabel.attributedText = attributedStr
    
        } else {
            let attributedStr = data.repoHumanName
                .asMutableAttributedString()
                .foregroundColor(tmpColor1)
                .font(.zlMediumFont(withSize: 16))
            nameLabel.attributedText = attributedStr
        }
    }
    
    func fillWithViewData(viewData data: ZLRepoInfoHeaderCellDataSourceAndDelegate) {
        delegate = data
        reloadData()
    }
    
    func justUpdateView() {
        reloadData()
    }
}



// MARK: - ZLRepoInfoHeaderButton
private class ZLRepoInfoHeaderButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(numLabel)
        addSubview(nameLabel)

        numLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1.5)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-1.5)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: View
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont.zlMediumFont(withSize: 17)
        label.textAlignment = .center
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textAlignment = .center
        return label
    }()
}
