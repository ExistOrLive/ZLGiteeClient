//
//  ZLWorkBoardContributionCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/7/24.
//

import Foundation
import UIKit
import ZLBaseExtension
import SnapKit
import ZLUIUtilities
import ZMMVVM

// MARK: - ZLWorkBoardContributionCellData
class ZLWorkBoardContributionCellData: ZMBaseTableViewCellViewModel {
        
    let stateModel : ZLWorkBoardStateModel
    
    init(stateModel : ZLWorkBoardStateModel) {
        self.stateModel = stateModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLWorkBoardContributionCell"
    }
    
    var login: String {
        stateModel.userModel?.login ?? ""
    }
}

// MARK: - ZLWorkBoardContributionCell
class ZLWorkBoardContributionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(contributionLabel)
        contentView.addSubview(contributionView)
        contentView.addSubview(lessLabel)
        contentView.addSubview(moreLabel)
        contentView.addSubview(levelStackView)
        
        contributionLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(20)
        }
        
        contributionView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(contributionLabel.snp.bottom).offset(10)
            make.height.equalTo(82)
        }
        
        
        lessLabel.snp.makeConstraints { make in
            make.centerY.equalTo(levelStackView)
            make.right.equalTo(levelStackView.snp.left).offset(-4)
        }
        
        levelStackView.snp.makeConstraints { make in
            make.top.equalTo(contributionView.snp.bottom).offset(10)
            make.height.equalTo(16)
            make.bottom.equalTo(-15)
        }
        
        moreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(levelStackView)
            make.left.equalTo(levelStackView.snp.right).offset(4)
            make.right.equalTo(-20)
        }

    }
    
    lazy var contributionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x000000)
        label.font = .zlMediumFont(withSize: 16)
        label.text = "贡献度"
        return label
    }()
    
    lazy var contributionView: ZLGiteeContributionsView = {
       let view = ZLGiteeContributionsView()
        return view
    }()
    
    lazy var lessLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x999999)
        label.font = .zlMediumFont(withSize: 10)
        label.text = "少"
        return label
    }()
    
    lazy var moreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x999999)
        label.font = .zlMediumFont(withSize: 10)
        label.text = "多"
        return label
    }()
    
    lazy var levelStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        for index in 1...5 {
            let view = UIView()
            view.layer.cornerRadius = 2.0
            view.backgroundColor = UIColor(named: "ZLContributionColor\(index)")
            view.snp.makeConstraints { make in
                make.size.equalTo(10)
            }
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
}

// MARK: ZMBaseViewUpdatableWithViewData
extension ZLWorkBoardContributionCell: ZMBaseViewUpdatableWithViewData {

    func zm_fillWithViewData(viewData: ZLWorkBoardContributionCellData) {
        contributionView.startLoad(loginName: viewData.login)
    }

}

