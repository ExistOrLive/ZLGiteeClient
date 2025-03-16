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
import ZMMVVM

class ZLWorkBoardItemCellData: ZMBaseTableViewCellViewModel {
    
    let type: ZLWorkboardButtonType
        
    init(type: ZLWorkboardButtonType) {
        self.type = type
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLWorkBoardItemCell"
    }
    
    override var zm_cellHeight: CGFloat {
        60
    }

    override func zm_onCellSingleTap() {
        switch type {
        case .companys:
            break
        case .orgs:
            let vc = ZLMyOrgListController()
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
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
            make.size.equalTo(CGSize(width: 40, height: 40))
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
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 16, height: 16))
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
                                                fontSize: 16,
                                                color: UIColor(rgb: 0xC4C4C4) ?? .black)
       return imageView
    }()

    lazy var singleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()
}

// MARK: - ZMBaseViewUpdatableWithViewData
extension ZLWorkBoardItemCell: ZMBaseViewUpdatableWithViewData {
   
    func zm_fillWithViewData(viewData: ZLWorkBoardItemCellData) {
        titleLabel.text = viewData.type.title
        avatarImageView.image = viewData.type.icon
        let indexPath = viewData.zm_indexPath
        let numberOfRowInCurrentSection = viewData.zm_rowNumberOfCurrentSection
        singleLineView.isHidden = (indexPath.row == numberOfRowInCurrentSection - 1)
    }
}
