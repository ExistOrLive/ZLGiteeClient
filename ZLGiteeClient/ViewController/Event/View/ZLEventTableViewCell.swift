//
//  ZLEventTableViewCell.swift
//  ZLGitHubClient
//
//  Created by ZM on 2019/11/25.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import YYText
import ZLUtilities
import ZLUIUtilities
import SDWebImage

class ZLEventTableViewCell: UITableViewCell, ZLViewUpdatableWithViewData {

    weak var delegate: ZLEventTableViewCellData?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.setUpUI()
    }

    func setUpUI() {
        selectionStyle = .none
        // containerView
        contentView.addSubview(containerView)
        containerView.addSubview(headImageButton)
        containerView.addSubview(actorNameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(eventDesLabel)
        containerView.addSubview(assistInfoView)
        containerView.addSubview(reportMoreButton)
        
        containerView.snp.makeConstraints({(make) -> Void in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10))
        })
     
        headImageButton.snp.makeConstraints({(make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        })

        actorNameLabel.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(headImageButton.snp.right).offset(10)
            make.centerY.equalTo(headImageButton)
        })
        
        timeLabel.snp.makeConstraints({(make) -> Void in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(actorNameLabel)
        })
        
        eventDesLabel.snp.makeConstraints({(make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(headImageButton.snp.bottom).offset(10)
        })
        
        assistInfoView.snp.makeConstraints { make in
            make.top.equalTo(eventDesLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20).priority(.medium)
        }
        
        reportMoreButton.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(assistInfoView.snp.bottom)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func hiddenReportButton(hidden: Bool) {
        self.reportMoreButton.isHidden = hidden
        if hidden {
            self.reportMoreButton.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        } else {
            self.reportMoreButton.snp.updateConstraints { (make) in
                make.height.equalTo(30)
            }
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(named: "ZLCellBack")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8.0
        return view
    }()

    lazy var headImageButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.layer.cornerRadius = 20.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(self.onAvatarButtonClicked(button:)), for: .touchUpInside)
        return button
    }()

    lazy var actorNameLabel: UILabel = {
        let actorNameLabel = UILabel()
        actorNameLabel.textColor = UIColor.init(named: "ZLLabelColor1") ?? UIColor.black
        actorNameLabel.font = .zlMediumFont(withSize: 16)
        return actorNameLabel
    }()

    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel.init()
        timeLabel.textColor = .label(withName: "ZLLabelColor2")
        timeLabel.font = .zlMediumFont(withSize: 15)
        return timeLabel
    }()

    lazy var eventDesLabel: YYLabel = {
        let eventDesLabel = YYLabel()
        eventDesLabel.numberOfLines = 0
        eventDesLabel.preferredMaxLayoutWidth = ZLScreenWidth - 50
        return eventDesLabel
    }()

    lazy var assistInfoView: UIView = {
        return UIView()
    }()

    lazy var reportMoreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(onReportButtonClicked), for: .touchUpInside)
        let str = NSAttributedString(string: ZLIconFont.More.rawValue, attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                                    .foregroundColor: UIColor.label(withName: "ICON_Common")])
        button.setAttributedTitle(str, for: .normal)
        return button
    }()
    
    
    func fillWithViewData(viewData: ZLEventTableViewCellData) {
        delegate = viewData
        headImageButton.sd_setBackgroundImage(with: URL(string: viewData.actorAvatar()),
                                              for: .normal,
                                              placeholderImage: UIImage(named: "default_avatar"))
        
        actorNameLabel.text = viewData.actorName()
        timeLabel.text = viewData.eventTimerStr()
        eventDesLabel.attributedText = viewData.eventDescription()
    }
    
    func justUpdateView() {
        
    }
}

// MARK: - action
extension ZLEventTableViewCell {
    @objc func onAvatarButtonClicked(button: UIButton) {
        self.delegate?.onAvatarClicked()
    }

    @objc func onReportButtonClicked() {
        self.delegate?.onReportClicked()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
}
