//
//  ZLRepoForksListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import UIKit
import ZLUIUtilities
import ZMMVVM
import ZLBaseExtension
import ZLUtilities

class ZLRepoForksListController: ZMTableViewController {

    let repoFullName: String
    /// login Name
    let loginName: String
    /// repoName
    let repoName: String
   
    var page: Int = 1
        
    init(repoFullName: String) {
        self.repoFullName = repoFullName
        let nameArray = repoFullName.split(separator: "/")
        self.loginName = String(nameArray.first ?? "")
        self.repoName = String(nameArray.last ?? "")
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "Forks"
        setRefreshView(type: .header)
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
        
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
    }
    

// MARK: - Refresh
    override func refreshLoadNewData() {
        ZLGiteeRequest.sharedProvider.requestRest(.repoForksList(login: loginName, repoName: repoName, page: 1, per_page: 20), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            self.endRefreshView(type: .header)
            if result, let array = model as? [ZLGiteeRepoModel] {
                self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                let newCellDatas = array.map { ZLRepositoryTableViewCellData(model: $0) }
                self.zm_addSubViewModels(newCellDatas)
                let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: newCellDatas)
                self.sectionDataArray = [sectionData]
                self.tableViewProxy.reloadData()
                self.viewStatus = newCellDatas.isEmpty ? .empty : .normal
                self.page = 2
            } else {
                self.viewStatus = self.sectionDataArray.first?.cellDatas.isEmpty ?? true ? .error : .normal
                ZLToastView.showMessage(msg ?? "", sourceView: self.contentView)
            }
        })
    }
    
    override func refreshLoadMoreData() {
        ZLGiteeRequest.sharedProvider.requestRest(.repoForksList(login: loginName, repoName: repoName, page: page, per_page: 20), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            self.endRefreshView(type: .footer)
            if result, let array = model as? [ZLGiteeRepoModel] {
                let newCellDatas = array.map { ZLRepositoryTableViewCellData(model: $0) }
                self.zm_addSubViewModels(newCellDatas)
                self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                self.tableViewProxy.reloadData()
                self.page = self.page + 1
            } else {
                ZLToastView.showMessage(msg ?? "", sourceView: self.contentView)
            }
        })
    }
}




