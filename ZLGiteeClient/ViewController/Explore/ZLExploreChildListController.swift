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
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
    }
    
    // MARK: - Refresh
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
    
    func loadData(isLoadNew: Bool) {
        let page = isLoadNew ? 1 : page
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
                if isLoadNew {
                    self.sectionDataArray.forEach{ $0.zm_removeFromSuperViewModel() }
                    let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: newCellDatas)
                    self.sectionDataArray = [sectionData]
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: newCellDatas)
                }
               
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                self.tableViewProxy.reloadData()
                self.endRefreshViews(noMoreData: newCellDatas.count < 20)
                self.page = page + 1
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                self.endRefreshViews()
                ZLToastView.showMessage(msg)
            }
            
        })
    }
}



// MARK: - JXSegmentedListContainerViewListDelegate
extension ZLExploreChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}


