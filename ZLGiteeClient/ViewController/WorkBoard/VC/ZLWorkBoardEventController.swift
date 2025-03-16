//
//  ZLWorkBoardEventController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/14.
//

import UIKit
import SnapKit
import Moya
import ZLUIUtilities
import ZMMVVM
import JXPagingView

class ZLWorkBoardEventController: ZMTableViewController {
    

    override func setupUI() {
        super.setupUI()
        title = "仓库"
        setRefreshView(type: .header)
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
    }
    
    override func refreshLoadNewData() {
        endRefreshView(type: .header)
    }
    
    override func refreshLoadMoreData() {
        endRefreshView(type: .footer)
    }
}

extension ZLWorkBoardEventController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        view
    }
    
    func listScrollView() -> UIScrollView {
        tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView)->()) {
        
    }
}
