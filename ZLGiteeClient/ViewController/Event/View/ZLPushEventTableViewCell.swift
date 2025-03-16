//
//  ZLPushEventTableViewCell.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/21.
//

import Foundation
import UIKit

class ZLPushEventTableViewCell: ZLEventTableViewCell {

    lazy var commitInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label 
    }()
    
    override func setUpUI() {
        super.setUpUI()
        assistInfoView.addSubview(commitInfoLabel)
        commitInfoLabel.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 10, right: 10))
        })
    }
    

    override func zm_fillWithViewData(viewData: ZLEventTableViewCellData) {
        super.zm_fillWithViewData(viewData: viewData)
        guard let pushEventCellData = viewData as? ZLPushEventTableViewCellData else {
            return
        }
        self.commitInfoLabel.attributedText = pushEventCellData.commitInfoAttributedStr()
    }
}
