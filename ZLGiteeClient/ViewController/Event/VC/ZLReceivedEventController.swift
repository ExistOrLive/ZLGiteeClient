//
//  ZLReceivedEventController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/15.
//

import Foundation
import ZLBaseUI
import ZLUIUtilities
import JXPagingView

class ZLReceivedEventController: ZLBaseViewController {
    
    /// lastId
    var prev_id: Int? = nil
    /// 一页限制20
    let limit = 20
    
    var scrollCallback: ((UIScrollView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        tableContainerView.startLoad()
    }
    
    
    func setUpUI() {
        title = "动态"
        setZLNavigationBarHidden(true)
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.top.equalTo(2.5)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    lazy var tableContainerView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewFooter()
        view.register(ZLEventTableViewCell.self, forCellReuseIdentifier: "ZLEventTableViewCell")
        view.register(ZLRepoEventTableViewCell.self, forCellReuseIdentifier: "ZLRepoEventTableViewCell")
        view.register(ZLPushEventTableViewCell.self, forCellReuseIdentifier: "ZLPushEventTableViewCell")
        view.delegate = self
        return view
    }()
}

// MARK: - ZLTableContainerViewDelegate
extension ZLReceivedEventController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        requestReceivedEvent(loadNew: true)
    }
    
    func zlLoadMoreData() {
        requestReceivedEvent(loadNew: false)
    }
    
    func zlScrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}

// MARK: - Request
extension ZLReceivedEventController {
    
    func requestReceivedEvent(loadNew: Bool) {
        let currentLogin = ZLGiteeOAuthUserServiceModel.sharedService.currentUserModel?.login ?? ""
        ZLGiteeRequest.sharedProvider.requestRest(.userReceivedEvent(loginName:currentLogin, 
                                                                     limit: 20,
                                                                     prev_id: loadNew ? nil : prev_id)) { [weak self] result, data, msg in
            guard let self else { return }
            if result, let eventArray = data as? [ZLGiteeEventModel] {
                let cellDatas = eventArray.map { ZLEventTableViewCellData.generateEventCellData(model: $0)}
                self.prev_id = eventArray.last?.id
                if loadNew {
                    self.removeAllSubViewModels()
                    self.addSubViewModels(cellDatas)
                    self.tableContainerView.resetCellDatas(cellDatas: cellDatas, 
                                                           hasMoreData: self.prev_id != nil )
                } else {
                    self.addSubViewModels(cellDatas)
                    self.tableContainerView.appendCellDatas(cellDatas: cellDatas,
                                                            hasMoreData: self.prev_id != nil )
                }
            } else {
                ZLToastView.showMessage(msg)
                self.tableContainerView.endRefresh()
            }
        }
    }
}

// MARK: - JXPagingViewListViewDelegate
extension ZLReceivedEventController : JXPagingViewListViewDelegate {
    func listView() -> UIView {
        view
    }
    
    func listScrollView() -> UIScrollView {
        tableContainerView.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView)->()) {
        scrollCallback = callback
    }
}

