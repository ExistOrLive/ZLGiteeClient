//
//  ZLRepoContentCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/14.
//

import UIKit
import ZLUtilities
import ZLUIUtilities

// MARK: - ZLRepoContentTableViewCellData
class ZLRepoContentTableViewCellData: ZLTableViewBaseCellData { 
    
    let model: ZLRepoContentNode
    
    init(model: ZLRepoContentNode) {
        self.model = model
        super.init()
        cellReuseIdentifier = "ZLRepoContentTableViewCell"
        cellHeight = 60
    }

    override func onCellSingleTap() {
        guard let content = model.content else { return }
        switch content.type {
        case "dir":
            guard let vc = viewController as? ZLRepoContentController else { return }
            vc.enterDir(model: model)
        case "file":
            let vc = ZLWebContentController()
            vc.requestURL = URL(string: content.html_url)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        default:
            break 
        }
    }
    
    func onLongPressAction(view: UIView) {
        guard let content = model.content,
              let vc = viewController,
              let url = URL(string: content.html_url) else { return }
        view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: vc)
    }
}

// MARK: - ZLRepoContentTableViewCell
class ZLRepoContentTableViewCell: UITableViewCell {

    private var longPressBlock: ((UIView) -> Void)?

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 30)
        label.textColor = UIColor(named: "ICON_Common")
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()

    private lazy var nextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ICON_Common")
        label.text = ZLIconFont.NextArrow.rawValue
        return label
    }()

    private lazy var seperateLine: UIView  = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()

    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

    private func setupUI() {

        self.contentView.backgroundColor = UIColor(named: "ZLCellBack")

        self.contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.centerY.equalToSuperview()
        }

        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(typeLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        self.contentView.addSubview(nextLabel)
        nextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }

        self.contentView.addSubview(seperateLine)
        seperateLine.snp.makeConstraints { make in
            make.height.equalTo(ZLSeperateLineHeight)
            make.bottom.right.equalToSuperview()
            make.left.equalTo(titleLabel)
        }

        contentView.addGestureRecognizer(longPressGesture)
    }

   

    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        longPressBlock?(self)
    }
}

extension ZLRepoContentTableViewCell: ZLViewUpdatableWithViewData {
    
    func fillWithViewData(viewData: ZLRepoContentTableViewCellData){
        guard let content = viewData.model.content else  { return }
        if content.type == "dir"{
            self.typeLabel.text = ZLIconFont.DirClose.rawValue
        } else if content.type == "file"{
            self.typeLabel.text = ZLIconFont.File.rawValue
        }
        self.titleLabel.text = content.name

        if let _ = URL(string: content.html_url) {
            longPressGesture.isEnabled = true
        } else {
            longPressGesture.isEnabled = false
        }

        self.longPressBlock = { [weak viewData] (view) in
            guard let viewData else { return }
            viewData.onLongPressAction(view: view)
        }
    }
    
    func justUpdateView() {
        
    }
}
    

