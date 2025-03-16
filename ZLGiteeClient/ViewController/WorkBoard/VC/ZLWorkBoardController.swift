//
//  ZLWorkBoardController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZMMVVM
import ZLUIUtilities


class ZLWorkBoardController: ZMTableViewController {
    
    lazy var stateModel: ZLWorkBoardStateModel = {
        ZLWorkBoardStateModel()
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateViewData()
        tableView.reloadData()
    }
    
    override func setupUI() {
        super.setupUI()
        isZmNavigationBarHidden = true
        
        tableView.register(ZLCommonSectionHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
        tableView.register(ZLWorkBoardEditHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLWorkBoardEditHeaderView")
        tableView.register(ZLWorkBoardHeaderCell.self,
                           forCellReuseIdentifier: "ZLWorkBoardHeaderCell")
        tableView.register(ZLWorkBoardContributionCell.self,
                           forCellReuseIdentifier: "ZLWorkBoardContributionCell")
        tableView.register(ZLWorkBoardItemCell.self,
                           forCellReuseIdentifier: "ZLWorkBoardItemCell")
        tableView.bounces = false
    }

}

// MARK: - cellData
extension ZLWorkBoardController {
    func generateViewData() {

        ///  workboardHeaderSection
        let workboardHeaderSectionData = ZMBaseTableViewSectionData()
        let headerCellData = ZLWorkBoardHeaderCellData(stateModel: stateModel)
        workboardHeaderSectionData.cellDatas = [headerCellData]
        workboardHeaderSectionData.footerData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        
        ///  workboardContributionSection
        let workboardContributionSectionData = ZMBaseTableViewSectionData()
        let contributionCellData = ZLWorkBoardContributionCellData(stateModel: stateModel)
        workboardContributionSectionData.cellDatas = [contributionCellData]
        workboardContributionSectionData.footerData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        
        
        ///  workboardOrgSection
        let workboardOrgSectionData = ZMBaseTableViewSectionData()
        workboardOrgSectionData.cellDatas = [ZLWorkBoardItemCellData(type: .companys),
                                             ZLWorkBoardItemCellData(type: .orgs)]
        
        ///  workboardOrgSection
        let workboardFixRepoSectionData = ZMBaseTableViewSectionData()
        let fixRepoViewData = ZLWorkBoardEditHeaderViewData(type: .fixedRepo)
        workboardFixRepoSectionData.headerData = fixRepoViewData
        
        sectionDataArray = [workboardHeaderSectionData,
                            workboardContributionSectionData,
                            workboardOrgSectionData,
                            workboardFixRepoSectionData]
        sectionDataArray.forEach { $0.zm_addSuperViewModel(self) }
    }
}
//
//// MARK: - ZLTableContainerViewDelegate
//extension ZLWorkBoardController: ZLTableContainerViewDelegate {
//    func zlLoadNewData() { }
//    func zlLoadMoreData() { }
//}
