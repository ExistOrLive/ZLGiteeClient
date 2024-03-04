//
//  ZLRepoCommitsListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/3.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLUtilities

class ZLRepoCommitsListController: ZLBaseViewController {

    let repoFullName: String
    /// login Name
    let loginName: String
    /// repoName
    let repoName: String
   
    var page: Int = 1
        
    init(repoFullName: String) {
        self.repoFullName = repoFullName
        let nameArray = repoFullName.split(separator: "/")
        self.loginName = String(nameArray.first ?? "")
        self.repoName = String(nameArray.last ?? "")
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
        title = "提交"
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
        view.register(ZLCommitTableViewCell.self, forCellReuseIdentifier: "ZLCommitTableViewCell")
        return view
    }()
    
}

// MARK: - ZLTableContainerViewDelegate
extension ZLRepoCommitsListController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        ZLGiteeRequest.sharedProvider.requestRest(.repoCommitsList(login: loginName, repoName: repoName, page: 1, per_page: 20), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let array = model as? [ZLGiteeCommitModel] {
                let cellDatas = self.subViewModels
                cellDatas.forEach { $0.removeFromSuperViewModel() }
                let newCellDatas = array.map { ZLCommitTableViewCellData(commitModel: $0) }
                self.addSubViewModels(newCellDatas)
                self.tableContainerView.resetCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                self.page = 2
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
    
    func zlLoadMoreData() {
        ZLGiteeRequest.sharedProvider.requestRest(.repoForksList(login: loginName, repoName: repoName, page: page, per_page: 20), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let array = model as? [ZLGiteeCommitModel] {
                let newCellDatas = array.map {  ZLCommitTableViewCellData(commitModel: $0)  }
                self.addSubViewModels(newCellDatas)
                self.tableContainerView.appendCellDatas(cellDatas: newCellDatas, hasMoreData: newCellDatas.count >= 20 )
                self.page = self.page + 1
            } else {
                self.tableContainerView.endRefresh()
            }
        })
    }
}
