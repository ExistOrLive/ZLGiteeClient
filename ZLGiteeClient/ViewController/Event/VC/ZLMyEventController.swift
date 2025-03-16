//
//  ZLMyEventController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/23.
//

import Foundation
import ZMMVVM
import ZLUIUtilities
import JXPagingView

class ZLMyEventController: ZMTableViewController {
    
    /// lastId
    var prev_id: Int? = nil
    /// 一页限制20
    let limit = 20
    
    var scrollCallback: ((UIScrollView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        requestReceivedEvent(loadNew: true)
    }

    override func setupUI() {
        title = "动态"
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
        
        tableView.register(ZLEventTableViewCell.self, forCellReuseIdentifier: "ZLEventTableViewCell")
        tableView.register(ZLRepoEventTableViewCell.self, forCellReuseIdentifier: "ZLRepoEventTableViewCell")
        tableView.register(ZLPushEventTableViewCell.self, forCellReuseIdentifier: "ZLPushEventTableViewCell")
        tableView.register(ZLIssueEventTableViewCell.self, forCellReuseIdentifier: "ZLIssueEventTableViewCell")
        tableView.register(ZLPullRequestEventTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestEventTableViewCell")
        tableView.register(ZLCommitCommentEventTableViewCell.self, forCellReuseIdentifier: "ZLCommitCommentEventTableViewCell")
    }
    
    override func refreshLoadNewData() {
        requestReceivedEvent(loadNew: true)
    }
    
    override func refreshLoadMoreData() {
        requestReceivedEvent(loadNew: false)
    }
    
    func zlScrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}

// MARK: - Request
extension ZLMyEventController {
    
    func requestReceivedEvent(loadNew: Bool) {
        let currentLogin = ZLGiteeOAuthUserServiceModel.sharedService.currentUserModel?.login ?? ""
        ZLGiteeRequest.sharedProvider.requestRest(.userEvent(loginName:currentLogin,
                                                                     limit: 20,
                                                                     prev_id: loadNew ? nil : prev_id)) { [weak self] result, data, msg in
            guard let self else { return }
            self.viewStatus = .normal
            self.endRefreshView(type: .footer)
            
            if result, let eventArray = data as? [ZLGiteeEventModel] {
                let cellDatas = eventArray.compactMap({
                    ZLEventTableViewCellData.generateEventCellData(model: $0)
                })
                self.prev_id = eventArray.last?.id
                
                if loadNew {
                    self.zm_removeAllSubViewModels()
                    self.zm_addSubViewModels(cellDatas)
                } else {
                    self.zm_addSubViewModels(cellDatas)
                }
                
                self.tableViewProxy.reloadData()
                self.viewStatus = (self.sectionDataArray.first?.cellDatas.isEmpty ?? true) ? .empty : .normal
            } else {
                self.viewStatus = self.sectionDataArray.isEmpty ? .error : .normal
                ZLToastView.showMessage(msg)
            }
        }
    }
}

// MARK: - JXPagingViewListViewDelegate
extension ZLMyEventController : JXPagingViewListViewDelegate {
    func listView() -> UIView {
        view
    }
    
    func listScrollView() -> UIScrollView {
        tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView)->()) {
        scrollCallback = callback
    }
}


