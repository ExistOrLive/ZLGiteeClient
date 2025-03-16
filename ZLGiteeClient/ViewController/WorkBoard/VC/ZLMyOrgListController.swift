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
        setRefreshView(type: .header)
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
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
                    sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.zm_addSubViewModels(newCellDatas)
                    let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: newCellDatas)
                    self.sectionDataArray = [sectionData]
                    self.tableViewProxy.reloadData()
                    self.viewStatus = newCellDatas.isEmpty ? .empty : .normal
                    self.page = 2
                } else {
                    self.zm_addSubViewModels(newCellDatas)
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                    self.tableViewProxy.reloadData()
                    self.page = self.page + 1
                }
                
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty  ? .error : .normal
                self.endRefreshView(type: loadNewData ? .header : .footer)
            }
        })
    }
}

