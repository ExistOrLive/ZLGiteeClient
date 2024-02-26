//
//  ZLCommonTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLCommonTableViewCellDataV2: ZLTableViewBaseCellData {

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
        self._cellHeight = cellHeight
        self.actionBlock = actionBlock
        super.init()
    }

    override func onCellSingleTap() {
        self.actionBlock?()
    }

    override var cellReuseIdentifier: String {
        "ZLCommonTableViewCell"
    }
    
    override var cellHeight: CGFloat {
        _cellHeight
    }
}

extension ZLCommonTableViewCellDataV2: ZLCommonTableViewCellDataSourceAndDelegate {
}
