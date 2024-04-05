//
//  ZLMyOrgListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/28.
//

import UIKit
import ZLBaseUI
import SnapKit
import Moya
import ZLUIUtilities

class ZLMyOrgListController: ZLBaseViewController {
        
    private var page: Int = 1
    private var per_page: Int = 20
    
    // ViewModel
    private var cellDatas: [ZLTableViewBaseCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableContainerView.startLoad()
    }
    
    func setupUI() {
        title = "组织"
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.setTableViewHeader()
        tableView.setTableViewFooter()
        tableView.register(ZLOrgTableViewCell.self, forCellReuseIdentifier: "ZLOrgTableViewCell")
        tableView.delegate = self
        return tableView
    }()
    
}


extension ZLMyOrgListController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        loadData(loadNewData: true)
    }
    
    func zlLoadMoreData() {
        loadData(loadNewData: false)
    }
}


// request
extension ZLMyOrgListController {
    func loadData(loadNewData: Bool) {
        
        if loadNewData == true {
            page = 1
        } else {
            page += 1
        }
        
        ZLGiteeRequest.sharedProvider.requestRest(.oauthUserOrgList(page: page, per_page: per_page),
                                                  completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let array = model as? [ZLGiteeOrgModel] {
                let newCellDatas = array.map { ZLOrgTableViewCellData(orgModel: $0)}
                if loadNewData {
                    let cellDatas = self.subViewModels
                    cellDatas.forEach { $0.removeFromSuperViewModel() }
                    self.addSubViewModels(newCellDatas)
                    self.tableContainerView.resetCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                    self.page = 2
                } else {
                    self.addSubViewModels(newCellDatas)
                    self.tableContainerView.appendCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                    self.page = self.page + 1
                }
                
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
}

