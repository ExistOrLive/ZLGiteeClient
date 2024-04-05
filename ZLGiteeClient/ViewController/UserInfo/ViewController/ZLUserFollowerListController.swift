//
//  ZLUserFollowerListController.swift
//  ZLGiteeClient
//
//  Created by ZhangX on 2022/5/21.
//

import UIKit
import ZLBaseUI
import SnapKit
import Moya
import ZLUIUtilities

class ZLUserFollowerListController: ZLBaseViewController {
    
    // Entry Params
    var login: String?
    
    private var page: Int = 1
    private var per_page: Int = 20
    
    // ViewModel
    private var cellDatas: [ZLTableViewBaseCellData] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableContainerView.startLoad()
    }
    
    func setupUI() {
        title = "粉丝"
        
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.setTableViewHeader()
        tableView.setTableViewFooter()
        tableView.register(ZLUserTableViewCell.self, forCellReuseIdentifier: "ZLUserTableViewCell")
        tableView.delegate = self
        return tableView
    }()
}

extension ZLUserFollowerListController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        loadData(loadNewData: true)
    }
    
    func zlLoadMoreData() {
        loadData(loadNewData: false)
    }
}

// request
extension ZLUserFollowerListController {
    func loadData(loadNewData: Bool) {
        
        guard let login = self.login,
           !login.isEmpty else {
            ZLToastView.showMessage("login 为空", sourceView:view)
            tableContainerView.endRefresh()
            return
        }

        if loadNewData == true {
            page = 1
        } else {
            page += 1
        }
        
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.userFollower(login: login, page: page, per_page: per_page)) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let dataStr = String(data: response.data, encoding: .utf8)
                if response.statusCode == 200 {
                    guard let followerArray =  [ZLGiteeUserModel].deserialize(from: dataStr, designatedPath: nil) else {
                        return
                    }
                    let cellDatas: [ZLUserTableViewCellData] =  followerArray.compactMap { model in
                        guard let model = model else {
                            return nil
                        }
                        return ZLUserTableViewCellData(userModel: model)
                    }
                    if loadNewData {
                        for cellData in self.cellDatas {
                            cellData.removeFromSuperViewModel()
                        }
                        self.addSubViewModels(cellDatas)
                        self.cellDatas = cellDatas
                        self.tableContainerView.resetCellDatas(cellDatas: self.cellDatas, hasMoreData: cellDatas.count >= self.per_page)
                        
                    } else {
                        self.addSubViewModels(cellDatas)
                        self.cellDatas.append(contentsOf: cellDatas)
                        self.tableContainerView.resetCellDatas(cellDatas: self.cellDatas, hasMoreData: cellDatas.count >= self.per_page)
                    }
            
                } else {
                    self.tableContainerView.endRefresh()
                    ZLToastView.showMessage(dataStr ?? "", sourceView: self.contentView)
                }
                
            case .failure(let error):
                self.tableContainerView.endRefresh()
                ZLToastView.showMessage(error.localizedDescription, sourceView: self.contentView)
            }
        }
    }
}
