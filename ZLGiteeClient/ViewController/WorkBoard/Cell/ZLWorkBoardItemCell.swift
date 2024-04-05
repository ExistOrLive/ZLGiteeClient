//
//  ZLWorkBoardItemCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/24.
//

import Foundation
import UIKit
import ZLUtilities
import SnapKit
import ZLUIUtilities

enum ZLWorkboardType {
    case repos                // 仓库
    case pullRequest          // Pull Requests
    case issues               // Issues
    case gists                // 代码片段
    case starRepos            // 星选集
    case orgs                 // 组织
    case companys             // 企业
    
    var title: String {
        switch self {
        case .repos:
            return "仓库"
        case .pullRequest:
            return "Pull Requests"
        case .issues:
            return "Issues"
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
        var iconfont: String = ""
        switch self {
        case .repos:
            iconfont = "\u{e74f}"
        case .pullRequest:
            iconfont = "\u{e798}"
        case .issues:
            iconfont = "\u{e70f}"
        case .gists:
            iconfont = "\u{e60f}"
        case .starRepos:
            iconfont = "\u{e7df}"
        case .orgs:
            iconfont = "\u{e6dd}"
        case .companys:
            iconfont = "\u{e61f}"
        }
        return UIImage.iconFontImage(withText: iconfont, fontSize: 20, imageSize: CGSize(width: 30, height: 30), color: .iconColor(withName: "ZLLabelColor1"))
    }
}

class ZLWorkBoardItemCellData: ZLTableViewBaseCellData {
    
    let type: ZLWorkboardType
    
    init(type: ZLWorkboardType) {
        self.type = type
        super.init()
        cellReuseIdentifier = "ZLWorkBoardItemCell"
        cellHeight = 50
    }

    override func onCellSingleTap() {
        switch type {
        case .issues:
            break
        default:
            break
        }
    }
}


class ZLWorkBoardItemCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .back(withName: "ZLCellBack")
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(singleLineView)
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }

        singleLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo( 1.0 / UIScreen.main.scale )
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
    }
    
    lazy var avatarImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.circle = true
        imageView.contentMode = .scaleAspectFit
       return imageView
    }()

    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .zlSemiBoldFont(withSize: 14)
        label.textColor = .label(withName: "ZLLabelColor1")
        label.textAlignment = .left
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.iconFontImage(withText: ZLIconFont.NextArrow.rawValue,
                                                fontSize: 12,
                                                color: UIColor.iconColor(withName: "ICON_Common"))
       return imageView
    }()

    lazy var singleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()
}

// MARK: - ZLViewUpdatableWithViewData
extension ZLWorkBoardItemCell: ZLViewUpdatableWithViewData {

    func fillWithViewData(viewData: ZLWorkBoardItemCellData){
        titleLabel.text = viewData.type.title
        avatarImageView.image = viewData.type.icon
    }
    
    func justUpdateView() {
        
    }
}
