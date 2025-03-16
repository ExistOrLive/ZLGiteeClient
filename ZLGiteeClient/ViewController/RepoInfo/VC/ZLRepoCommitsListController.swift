//
//  ZLRepoCommitsListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/3.
//

import UIKit
import ZLUIUtilities
import ZMMVVM
import ZLBaseExtension
import ZLUtilities

class ZLRepoCommitsListController: ZMTableViewController {

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
        super.init(style: .grouped)
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
        title = "提交"
        setRefreshViews(types: [.header,.footer])
        
        tableView.register(ZLCommitTableViewCell.self, forCellReuseIdentifier: "ZLCommitTableViewCell")
    }
    
    // MARK: - Refresh

    override func refreshLoadNewData() {
        ZLGiteeRequest.sharedProvider.requestRest(.repoCommitsList(login: loginName, repoName: repoName, page: 1, per_page: 20), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            self.endRefreshView(type: .header)
            self.viewStatus = .normal
            if result, let array = model as? [ZLGiteeCommitModel] {
                self.page = 2
                
                sectionDataArray.forEach{ $0.zm_removeFromSuperViewModel() }
                let newCellDatas = array.map { ZLCommitTableViewCellData(commitModel: $0) }
                self.zm_addSubViewModels(newCellDatas)
                let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: newCellDatas)
                self.sectionDataArray = [sectionData]
                self.tableViewProxy.reloadData()
                self.endRefreshViews(noMoreData: newCellDatas.count < 20)
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
            } else {
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                ZLToastView.showMessage(msg, sourceView: self.contentView)
            }
        })
    }
    
    override func refreshLoadMoreData() {
        ZLGiteeRequest.sharedProvider.requestRest(.repoCommitsList(login: loginName, repoName: repoName, page: page, per_page: 20), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            self.endRefreshView(type: .footer)
            self.viewStatus = .normal
            if result, let array = model as? [ZLGiteeCommitModel] {
                let newCellDatas = array.map { ZLCommitTableViewCellData(commitModel: $0) }
                self.zm_addSubViewModels(newCellDatas)
                self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                self.tableViewProxy.reloadData()
                self.endRefreshViews(noMoreData: newCellDatas.count < 20)
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                self.page = self.page + 1
            } else {
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                ZLToastView.showMessage(msg, sourceView: self.contentView)
            }
        })
    }
}
