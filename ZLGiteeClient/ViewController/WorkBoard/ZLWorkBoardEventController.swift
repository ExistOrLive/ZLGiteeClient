//
//  ZLWorkBoardEventController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/14.
//

import UIKit
import ZLBaseUI
import SnapKit
import Moya
import ZLUIUtilities
import JXPagingView

class ZLWorkBoardEventController: ZLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        title = "仓库"
        contentView.addSubview(tableContainerView)
    setZLNavigationBarHidden(true)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.setTableViewHeader()
        tableView.setTableViewFooter()
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.delegate = self
        return tableView
    }()
}

extension ZLWorkBoardEventController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        
    }
    func zlLoadMoreData() {
        
    }
}

extension ZLWorkBoardEventController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        view
    }
    
    func listScrollView() -> UIScrollView {
        tableContainerView.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView)->()) {
        
    }
}
