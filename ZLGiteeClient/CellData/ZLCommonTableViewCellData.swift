//
//  ZLCommonTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLCommonTableViewCellData: ZLTableViewBaseCellData {

    private var _canClick: Bool = false
    private var _title: String = ""
    private var _info: String = ""
    private var _actionBlock: (() -> Void)?

    init(canClick: Bool,
         title: String,
         info: String,
         cellHeight: CGFloat,
         actionBlock:(() -> Void)? = nil) {
        _canClick = canClick
        _title = title
        _info = info
        _actionBlock = actionBlock
        super.init()
        self.cellHeight = cellHeight
        self.cellReuseIdentifier = "ZLCommonTableViewCell"
    }

    override func onCellSingleTap() {
       _actionBlock?()
    }
}

extension ZLCommonTableViewCellData: ZLCommonTableViewCellDataSourceAndDelegate {

    var canClick: Bool {
        _canClick
    }

    var title: String {
        _title
    }

    var info: String {
        _info
    }

}
