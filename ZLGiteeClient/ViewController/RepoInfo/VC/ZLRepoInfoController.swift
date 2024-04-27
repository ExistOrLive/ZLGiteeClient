//
//  ZLRepoInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLUtilities

class ZLRepoInfoController: ZLBaseViewController {
    
    let stateModel: ZLRepoInfoStateModel

    // viewModel
    var sectionDatas: [ZLTableViewBaseSectionData] = []
    /// 分支cellData
    weak var branchCellData: ZLCommonTableViewCellDataV2?
    
    init(repoFullName: String) {
        self.stateModel = ZLRepoInfoStateModel(repoFullName: repoFullName)
        super.init(nibName: nil, bundle: nil)
        self.stateModel.delegate = self
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
        title = stateModel.repoFullName
        
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        zlNavigationBar.rightButton = moreButton
    }
    
    // MARK: - lazy view
    
    lazy var moreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        return  button
    }()
    
    lazy var tableContainerView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.delegate = self
        view.register(ZLRepoInfoHeaderCell.self, forCellReuseIdentifier: "ZLRepoInfoHeaderCell")
        view.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        view.register(ZLCommonSectionHeaderFooterView.self, forViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
        view.tableViewFooter = readMeView
        return view
    }()
    
    lazy var readMeView: ZLReadMeView = {
        let readMeView: ZLReadMeView = ZLReadMeView()
        readMeView.delegate = self
        return readMeView
    }()
    
}

// MARK: - Rows
extension ZLRepoInfoController {
    
    func generateCellDatas() {
      
        guard let _ = stateModel.repoInfo else {
            tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
            return
        }
        
        for sectionData in sectionDatas {
            sectionData.removeFromSuperViewModel()
        }
        sectionDatas.removeAll()
        
        /// header
        let headerCellData = ZLRepoHeaderCellData(stateModel: stateModel)
        addSubViewModel(headerCellData)
        let headerSectionData = ZLTableViewBaseSectionData(cellDatas: [headerCellData])
        headerSectionData.sectionHeaderViewData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDatas.append(headerSectionData)
        
        /// item
        let commitCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                       title: "提交",
                                                       info: "",
                                                       cellHeight: 50,
                                                       actionBlock: { [weak self] in
            self?.onCommitClicked()
        })
    
        let branchCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                         title: "分支",
                                                         info: stateModel.currentBranch ?? "",
                                                         cellHeight: 50,
                                                         actionBlock: { [weak self] in
            self?.onBranchClicked()
            
        })
        
        let languageCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                           title: "语言",
                                                           info: stateModel.repoInfo?.language ?? "" ,
                                                           cellHeight: 50,
                                                           actionBlock: { [weak self] in
            self?.onLanguageClicked()
        })
        
        let codeCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                     title: "代码",
                                                     info: "",
                                                     cellHeight: 50,
                                                     actionBlock: {  [weak self] in
            self?.onCodeClicked()
            
        })
        
   
        let prCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                   title: "合并请求",
                                                   info:"",
                                                   cellHeight: 50,
                                                   actionBlock: { [weak self] in
            self?.onPrClicked()
        })
        let itemCellDatas: [ZLTableViewBaseCellData] = [commitCellData,
                                                        branchCellData,
                                                        languageCellData,
                                                        codeCellData,
                                                        prCellData]
        addSubViewModels(itemCellDatas)
        
        let itemSectionData = ZLTableViewBaseSectionData(cellDatas: itemCellDatas)
        headerSectionData.sectionHeaderViewData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        headerSectionData.sectionFooterViewData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDatas.append(itemSectionData)
        
        tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
    }
}

// MARK: - Action
extension ZLRepoInfoController {
    
    func onCommitClicked() {
        let controller = ZLRepoCommitsListController(repoFullName: stateModel.repoFullName)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func onBranchClicked() {
        ZLRepoBranchesView.showRepoBranchedView(login: stateModel.loginName,
                                                repoName: stateModel.repoName,
                                                currentBranch: stateModel.currentBranch ?? "") { [weak self] newBranch in
            self?.stateModel.changeBranch(newBranch: newBranch)
            self?.generateCellDatas()
        }
    }
    
    func onLanguageClicked() {
        
//        guard let fullName = fullName,
//              let language = presenter?.repoModel?.language,
//              !language.isEmpty else {
//                        return
//                    }
//        ZLRepoLanguagesPercentView.showRepoLanguagesPercentView(fullName: fullName)
    }
    
    func onCodeClicked() {
//        let controller = ZLRepoContentController()
//        controller.branch = presenter?.currentBranch
//        controller.repoFullName = fullName
//        controller.path = ""
//        self.viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onPrClicked() {
//        let controller = ZLRepoPullRequestController.init()
//        controller.repoFullName = fullName
//        self.viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    // action
    @objc func onMoreButtonClick(button: UIButton) {
        guard let htmlUrl = stateModel.repoInfo?.html_url,
              let url = URL(string: htmlUrl) else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }
       
}


// MARK: - ZLTableContainerViewDelegate
extension ZLRepoInfoController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        
        stateModel.loadRepoRequest { [weak self] result, msg in
            guard let self = self else { return }
            if result {
                self.generateCellDatas()
            } else if !result, !msg.isEmpty {
                ZLToastView.showMessage(msg,sourceView: self.view)
            }
            self.tableContainerView.endRefresh()
        }
        
        stateModel.getRepoStarStatus()
        
        stateModel.getRepoWatchStatus()
        
        readMeView.startLoad(fullName: stateModel.repoFullName, ref: nil)
    }
    
    func zlLoadMoreData() {
        // No Implementation
    }
}

// MARK: - ZLRepoInfoStateModelDelegate
extension ZLRepoInfoController: ZLRepoInfoStateModelDelegate {
    func onNeedReloadData() {
        tableContainerView.reloadData()
    }
    
    func onWatchStatusUpdate() {
        tableContainerView.reloadData()
        zlLoadNewData()
    }
    func onStarStatusUpdate() {
        tableContainerView.reloadData()
        zlLoadNewData()
    }
}

// MARK: - ZLReadMeViewDelegate
extension ZLRepoInfoController: ZLReadMeViewDelegate {
    
    @objc func onLinkClicked(url: URL?) {
      
    }

    @objc func notifyNewHeight(height: CGFloat) {
        if tableContainerView.tableViewFooter != nil {
            readMeView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
            tableContainerView.tableViewFooter = readMeView
        }
    }
}
