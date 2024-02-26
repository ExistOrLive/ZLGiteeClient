//
//  ZLSearchChildListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import Foundation
import ZLBaseUI
import ZLBaseExtension
import ZLUIUtilities
import JXSegmentedView


class ZLSearchChildListController: ZLBaseViewController {

    let type: SearchType
    
    var q: String = ""
   
    var page: Int = 1
        
    init(type: SearchType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setZLNavigationBarHidden(true)
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setNewQuery(q: String) {
        self.q = q
        if !q.isEmpty {
            tableContainerView.startLoad()
        }
    }
    
    // MARK: - lazy view
    
    lazy var tableContainerView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.setTableViewFooter()
        view.delegate = self
        view.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        view.register(ZLUserTableViewCell.self, forCellReuseIdentifier: "ZLUserTableViewCell")
        view.register(ZLIssueTableViewCell.self, forCellReuseIdentifier: "ZLIssueTableViewCell")
        return view
    }()
    
}

// MARK: - JXSegmentedListContainerViewListDelegate
extension ZLSearchChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}

// MARK: - ZLTableContainerViewDelegate
extension ZLSearchChildListController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        var request: ZLGiteeRequest = .searchRepos(q: q, page: 1, per_page: 20)
        switch type {
        case .repo:
            request = .searchRepos(q: q, page: 1, per_page: 20)
        case .user:
            request = .searchUsers(q: q, page: 1, per_page: 20)
        case .issue:
            request = .searchIssues(q: q, page: 1, per_page: 20)
        }
        
        ZLGiteeRequest.sharedProvider.requestRest(request, completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result {
               
                let cellDatas = self.subViewModels
                cellDatas.forEach { $0.removeFromSuperViewModel() }
                
                var newCellDatas: [ZLTableViewBaseCellData] = []
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
        
                self.addSubViewModels(newCellDatas)
                self.tableContainerView.resetCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                self.page = 2
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
    
    func zlLoadMoreData() {

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
                
                var newCellDatas: [ZLTableViewBaseCellData] = []
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
                
                self.addSubViewModels(newCellDatas)
                self.tableContainerView.appendCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                self.page = self.page + 1
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
}

