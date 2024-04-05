//
//  ZLWorkBoardItemController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/24.
//

import Foundation
import ZLBaseUI
import ZLUIUtilities
import JXPagingView

class ZLWorkBoardItemController: ZLBaseViewController {
    
    var sectionDatas: [ZLTableViewBaseSectionData] = []
    
    var scrollCallback: ((UIScrollView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateViewData()
        tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
    }
    
    func setupUI() {
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.delegate = self
        tableView.register(ZLCommonSectionHeaderFooterView.self,
                           forViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
        tableView.register(ZLWorkBoardItemCell.self,
                           forCellReuseIdentifier: "ZLWorkBoardItemCell")
        return tableView
    }()
}

extension ZLWorkBoardItemController {
   
    func generateViewData() {

        let workItemSectionData = ZLTableViewBaseSectionData()
        workItemSectionData.sectionHeaderViewData = ZLCommonSectionHeaderFooterViewData(title: "工作项",
                                                                                        titleColor: .label(withName: "ZLLabelColor1"),
                                                                                        titleFont: .zlMediumFont(withSize: 16),
                                                                                        titleEdge: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20),
                                                                                        backgroundColor: .clear)
        let workItemTypes: [ZLWorkboardType] = [.pullRequest,.issues,.gists,.starRepos]
        let workItemCellDatas = workItemTypes.map({ type in
            return ZLWorkBoardItemCellData(type: type)
        })
        addSubViewModels(workItemCellDatas)
        workItemSectionData.cellDatas = workItemCellDatas
    
        sectionDatas = [workItemSectionData]
    }
}

// MARK: - JXPagingViewListViewDelegate
extension ZLWorkBoardItemController : JXPagingViewListViewDelegate {
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


// MARK: - ZLTableContainerViewDelegate
extension ZLWorkBoardItemController: ZLTableContainerViewDelegate {
    func zlScrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}
