//
//  ZLUserReposListController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLBaseUI
import SnapKit
import Moya
import ZLUIUtilities

class ZLUserReposListController: ZLBaseViewController {
    
    // Entry Params
    var login: String?
    
    // ViewModel
    private var cellDatas: [ZLTableViewBaseCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableContainerView.startLoad()
    }
    
    func setupUI() {
        title = "仓库"
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.setTableViewHeader()
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.delegate = self
        return tableView
    }()
    
}


extension ZLUserReposListController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        loadData(loadNewData: true)
    }
    
    func zlLoadMoreData() {
        loadData(loadNewData: false)
    }
}


// request
extension ZLUserReposListController {
    func loadData(loadNewData: Bool) {
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.userPublicRepos(login: login ?? "")) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let dataStr = String(data: response.data, encoding: .utf8)
                
                if response.statusCode == 200 {
                    guard let repoArray =  [ZLGiteeRepoModel].deserialize(from: dataStr, designatedPath: nil) else {
                        return
                    }
                    let cellDatas: [ZLRepositoryTableViewCellData] = repoArray.compactMap { model in
                        guard let model = model else {
                            return nil
                        }
                        return ZLRepositoryTableViewCellData(model: model)
                    }
                    self.addSubViewModels(cellDatas)
                    for cellData in self.cellDatas {
                        cellData.removeFromSuperViewModel()
                    }
                    self.cellDatas = cellDatas
                    self.tableContainerView.resetCellDatas(cellDatas: cellDatas, hasMoreData: false)
                
                } else {
                    print(dataStr)
                }
                
            case .failure(let error):
                self.tableContainerView.endRefresh()
                print(error)
            }
        }
    }
}
