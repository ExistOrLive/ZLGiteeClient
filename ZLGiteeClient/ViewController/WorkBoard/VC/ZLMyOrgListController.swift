//
//  ZLMyOrgListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/28.
//

import UIKit
import SnapKit
import Moya
import ZLUIUtilities
import ZMMVVM

class ZLMyOrgListController: ZMTableViewController {
        
    private var page: Int = 1
    private var per_page: Int = 20
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "组织"
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLOrgTableViewCell.self, forCellReuseIdentifier: "ZLOrgTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Refresh
    override func refreshLoadNewData() {
        loadData(loadNewData: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(loadNewData: false)
    }
}


// request
extension ZLMyOrgListController {
    func loadData(loadNewData: Bool) {
        
        var page = 0
        if loadNewData == true {
            page = 1
        } else {
            page = self.page
        }
        
        ZLGiteeRequest.sharedProvider.requestRest(.oauthUserOrgList(page: page, per_page: per_page),
                                                  completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let array = model as? [ZLGiteeOrgModel] {
                let newCellDatas = array.map { ZLOrgTableViewCellData(orgModel: $0)}
                self.zm_addSubViewModels(newCellDatas)
                
                if loadNewData {
                    sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: newCellDatas)
                    self.sectionDataArray = [sectionData]
                    self.page = 2
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                    self.page = self.page + 1
                }
                self.tableViewProxy.reloadData()
                self.viewStatus = tableViewProxy.isEmpty ? .empty : .normal
                self.endRefreshViews(noMoreData: newCellDatas.count < per_page)
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty  ? .error : .normal
                self.endRefreshViews()
            }
        })
    }
}

