//
//  ZLExploreChildListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import Foundation
import ZLBaseExtension
import ZLUIUtilities
import ZMMVVM
import JXSegmentedView


class ZLExploreChildListController: ZMTableViewController {

    let type: ExploreType
   
    var page: Int = 1
        
    init(type: ExploreType) {
        self.type = type
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
        isZmNavigationBarHidden = true 
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
    }
    
    // MARK: - Refresh
    override func refreshLoadNewData() {
        var request: ZLGiteeRequest = .latestRepoList(page: 1, per_page: 20)
        switch type {
        case .recommend:
            request = .recommendRepoList(page: 1, per_page: 20)
        case .latest:
            request = .latestRepoList(page: 1, per_page: 20)
        case .hot:
            request = .popularRepoList(page: 1, per_page: 20)
        }
        
        ZLGiteeRequest.sharedProvider.requestRest(request, completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let array = model as? [ZLGiteeRepoModelV3] {
                self.sectionDataArray.forEach{ $0.zm_removeFromSuperViewModel() }
                let newCellDatas = array.map { ZLRepositoryTableViewCellDataForV3API(model: $0) }
                self.zm_addSubViewModels(newCellDatas)
                let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: newCellDatas)
                self.sectionDataArray = [sectionData]
                self.tableViewProxy.reloadData()
                self.viewStatus = newCellDatas.isEmpty ? .empty : .normal
                self.page = 2
            } else {
                self.viewStatus = self.sectionDataArray.first?.cellDatas.isEmpty ?? true ? .error : .normal
            }
            self.endRefreshView(type: .header)
        })
    }
    
    override func refreshLoadMoreData() {
        var request: ZLGiteeRequest = .latestRepoList(page: page, per_page: 20)
        switch type {
        case .recommend:
            request = .recommendRepoList(page: page, per_page: 20)
        case .latest:
            request = .latestRepoList(page: page, per_page: 20)
        case .hot:
            request = .popularRepoList(page: page, per_page: 20)
        }
        ZLGiteeRequest.sharedProvider.requestRest(request, completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let array = model as? [ZLGiteeRepoModelV3] {
                let newCellDatas = array.map {  ZLRepositoryTableViewCellDataForV3API(model: $0) }
                self.zm_addSubViewModels(newCellDatas)
                self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                self.tableViewProxy.reloadData()
                self.page = self.page + 1
            }
            self.endRefreshView(type: .footer)
        })
    }
}



// MARK: - JXSegmentedListContainerViewListDelegate
extension ZLExploreChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}


