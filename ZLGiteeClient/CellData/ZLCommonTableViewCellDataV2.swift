//
//  ZLCommonTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZMMVVM

class ZLCommonTableViewCellDataV2: ZMBaseTableViewCellViewModel {

    var canClick: Bool = false
    var title: String = ""
    var info: String = ""
    var _cellHeight: CGFloat = 0.0
    var actionBlock: (() -> Void)?

    init(canClick: Bool,
         title: String,
         info: String,
         cellHeight: CGFloat,
         actionBlock:(() -> Void)? = nil) {
        self.canClick = canClick
        self.title = title
        self.info = info
        self.actionBlock = actionBlock
        super.init()
        self._cellHeight = cellHeight
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLCommonTableViewCell"
    }
    
    override var zm_cellHeight: CGFloat {
        _cellHeight
    }

    override func zm_onCellSingleTap() {
        self.actionBlock?()
    }
}

extension ZLCommonTableViewCellDataV2: ZLCommonTableViewCellDataSourceAndDelegate {
}
