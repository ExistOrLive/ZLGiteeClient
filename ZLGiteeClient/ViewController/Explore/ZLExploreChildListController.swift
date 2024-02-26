//
//  ZLExploreChildListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import Foundation
import ZLBaseUI
import ZLBaseExtension
import ZLUIUtilities
import JXSegmentedView


class ZLExploreChildListController: ZLBaseViewController {

    let type: ExploreType
   
    var page: Int = 1
        
    init(type: ExploreType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupUI()
            
        tableContainerView.startLoad()
    }
    
    func setupUI() {
        setZLNavigationBarHidden(true)
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - lazy view
    
    lazy var tableContainerView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.setTableViewFooter()
        view.delegate = self
        view.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        return view
    }()
    
}

// MARK: - JXSegmentedListContainerViewListDelegate
extension ZLExploreChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}

// MARK: - ZLTableContainerViewDelegate
extension ZLExploreChildListController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
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
                let cellDatas = self.subViewModels
                cellDatas.forEach { $0.removeFromSuperViewModel() }
                let newCellDatas = array.map { ZLRepositoryTableViewCellDataForV3API(model: $0) }
                self.addSubViewModels(newCellDatas)
                self.tableContainerView.resetCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                self.page = 2
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
    
    func zlLoadMoreData() {
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
                self.addSubViewModels(newCellDatas)
                self.tableContainerView.appendCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                self.page = self.page + 1
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
}



