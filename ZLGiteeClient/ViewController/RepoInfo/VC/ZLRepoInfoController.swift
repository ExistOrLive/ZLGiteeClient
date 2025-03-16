//
//  ZLRepoInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM
import ZLBaseExtension
import ZLUtilities

class ZLRepoInfoController: ZMTableViewController {
    
    let stateModel: ZLRepoInfoStateModel
    
    /// 分支cellData
    weak var branchCellData: ZLCommonTableViewCellDataV2?
    
    init(repoFullName: String) {
        self.stateModel = ZLRepoInfoStateModel(repoFullName: repoFullName)
        super.init(style: .grouped)
        self.stateModel.delegate = self
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
        title = stateModel.repoFullName
        zmNavigationBar.addRightView(moreButton)
        
        tableView.register(ZLRepoInfoHeaderCell.self, forCellReuseIdentifier: "ZLRepoInfoHeaderCell")
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.register(ZLCommonSectionHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
        tableView.tableFooterView = readMeView
        
        setRefreshView(type: .header)
        
    }
    
    override func refreshLoadNewData() {
        
        stateModel.loadRepoRequest { [weak self] result, msg in
            guard let self = self else { return }
            self.viewStatus = .normal
            self.endRefreshView(type: .header)
            if result {
                self.title = self.stateModel.repoInfo?.human_name
                self.generateCellDatas()
                self.tableViewProxy.reloadData()
            } else if !result, !msg.isEmpty {
                ZLToastView.showMessage(msg,sourceView: self.view)
            }
        }
        
        stateModel.getRepoStarStatus()
        
        stateModel.getRepoWatchStatus()
        
        readMeView.startLoad(fullName: stateModel.repoFullName, ref: nil)
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
            return
        }
        
        
        sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
        sectionDataArray.removeAll()
  
        /// header
        let headerSectionData = ZMBaseTableViewSectionData()
        headerSectionData.cellDatas = [ZLRepoHeaderCellData(stateModel: stateModel)]
        headerSectionData.headerData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDataArray.append(headerSectionData)
        

        
        /// item
        let itemSectionData = ZMBaseTableViewSectionData()
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
        
        itemSectionData.cellDatas = [commitCellData,
                                     branchCellData,
                                     languageCellData,
                                     codeCellData,
                                     prCellData]
        itemSectionData.headerData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        itemSectionData.footerData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDataArray.append(itemSectionData)
      
        sectionDataArray.forEach { $0.zm_addSuperViewModel(self) }
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
        let controller = ZLRepoContentController(loginName: stateModel.loginName,
                                                 repoName: stateModel.repoName,
                                                 ref: stateModel.currentBranch)
        self.navigationController?.pushViewController(controller, animated: true)
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


// MARK: - ZLRepoInfoStateModelDelegate
extension ZLRepoInfoController: ZLRepoInfoStateModelDelegate {
    func onNeedReloadData() {
        tableViewProxy.reloadData()
    }
    
    func onWatchStatusUpdate() {
        tableViewProxy.reloadData()
        refreshLoadNewData()
    }
    func onStarStatusUpdate() {
        tableViewProxy.reloadData()
        refreshLoadNewData()
    }
}

// MARK: - ZLReadMeViewDelegate
extension ZLRepoInfoController: ZLReadMeViewDelegate {
    
    @objc func onLinkClicked(url: URL?) {
      
    }

    @objc func notifyNewHeight(height: CGFloat) {
        if tableView.tableFooterView != nil {
            readMeView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
            tableView.tableFooterView = readMeView
        }
    }
}
