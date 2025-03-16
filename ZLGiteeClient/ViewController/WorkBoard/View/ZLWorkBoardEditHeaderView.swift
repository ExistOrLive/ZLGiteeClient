//
//  ZLWorkBoardEditHeaderView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/8/14.
//

import Foundation
import UIKit
import ZLBaseExtension
import ZLUIUtilities
import ZMMVVM

enum ZLWorkBoardEditHeaderViewType {
    case fixedRepo
    case shortcut
}

class ZLWorkBoardEditHeaderViewData: ZMBaseTableViewReuseViewModel {
    let type: ZLWorkBoardEditHeaderViewType
    
   init(type: ZLWorkBoardEditHeaderViewType) {
        self.type = type
        super.init()
    }
    
    override var zm_viewReuseIdentifier: String {
        return "ZLWorkBoardEditHeaderView"
    }

    override var zm_viewHeight: CGFloat {
        52
    }
    
    func onEditAction() {
        
    }
}


class ZLWorkBoardEditHeaderView: UITableViewHeaderFooterView {
    
    var delegate: ZLWorkBoardEditHeaderViewData? {
        zm_viewModel as? ZLWorkBoardEditHeaderViewData
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(editButton)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
        }
    }
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .zlMediumFont(withSize: 18)
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "workboard_edit"), for: .normal)
        button.addTarget(self, action: #selector(onEditButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    @objc func onEditButtonClicked() {
        delegate?.onEditAction()
    }
    
}

extension ZLWorkBoardEditHeaderView: ZMBaseViewUpdatableWithViewData {

    func zm_fillWithViewData(viewData: ZLWorkBoardEditHeaderViewData) {
        switch viewData.type {
        case .fixedRepo:
            titleLabel.text = "收藏的仓库"
        case .shortcut:
            titleLabel.text = "快捷方式 "
        }
    }
}
