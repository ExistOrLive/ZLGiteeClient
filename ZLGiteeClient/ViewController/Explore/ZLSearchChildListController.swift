//
//  ZLSearchChildListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import Foundation
import ZLBaseExtension
import ZLUIUtilities
import ZMMVVM
import JXSegmentedView


class ZLSearchChildListController: ZMTableViewController {
    
    let type: SearchType
    
    var q: String = ""
    
    var page: Int = 1
    
    init(type: SearchType) {
        self.type = type
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.register(ZLUserTableViewCell.self, forCellReuseIdentifier: "ZLUserTableViewCell")
        tableView.register(ZLIssueTableViewCell.self, forCellReuseIdentifier: "ZLIssueTableViewCell")
    }
    
    func setNewQuery(q: String) {
        self.q = q
        if !q.isEmpty {
            refreshLoadNewData()
        }
    }
    
    // MARK: - Refresh
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }

}

// MARK: - request
extension ZLSearchChildListController {
    func loadData(isLoadNew: Bool)  {
        var page = isLoadNew ? 1 : self.page
        var request: ZLGiteeRequest = .searchRepos(q: q, page: page, per_page: 20)
        switch type {
        case .repo:
            request = .searchRepos(q: q, page: page, per_page: 20)
        case .user:
            request = .searchUsers(q: q, page: page, per_page: 20)
        case .issue:
            request = .searchIssues(q: q, page: page, per_page: 20)
        }
        
        ZLGiteeRequest.sharedProvider.requestRest(request, completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result{
                
                var newCellDatas: [ZMBaseTableViewCellViewModel] = []
                switch self.type {
                case .repo:
                    if let array = model as? [ZLGiteeRepoModel]{
                        newCellDatas = array.map { ZLRepositoryTableViewCellData(model: $0) }
                    }
                case .user:
                    if let array = model as? [ZLGiteeUserModel]{
                        newCellDatas = array.map { ZLUserTableViewCellData(userModel: $0) }
                    }
                case .issue:
                    if let array = model as? [ZLGiteeIssueModel]{
                        newCellDatas = array.map { ZLIssueTableViewCellData(issueModel: $0) }
                    }
                }
            
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: newCellDatas)]
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                }
                self.zm_addSubViewModels(newCellDatas)
                self.tableViewProxy.reloadData()
                
                self.page = isLoadNew ? 2 : self.page + 1
                
                self.endRefreshViews(noMoreData: newCellDatas.count < 20)
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                ZLToastView.showMessage(msg)
                self.endRefreshViews()
            }
        })
    }
}




// MARK: - JXSegmentedListContainerViewListDelegate
extension ZLSearchChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}

