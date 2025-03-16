//
//  ZLUserFollowingListController.swift
//  ZLGiteeClient
//
//  Created by ZhangX on 2022/5/25.
//

import UIKit
import SnapKit
import Moya
import ZLUIUtilities
import ZMMVVM

class ZLUserFollowingListController: ZMTableViewController {
    
    // Entry Params
    var login: String?
    
    private var page: Int = 1
    private var per_page: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "关注"
        setRefreshView(type: .header)
        setRefreshView(type: .footer)
        tableView.register(ZLUserTableViewCell.self,
                           forCellReuseIdentifier: "ZLUserTableViewCell")
    }
    
    
    override func refreshLoadNewData() {
        loadData(loadNewData: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(loadNewData: false)
    }
    
}
// request
extension ZLUserFollowingListController {
    func loadData(loadNewData: Bool) {
        
        guard let login = self.login,
           !login.isEmpty else {
            self.viewStatus = .normal
            self.endRefreshViews(noMoreData: true)
            return
        }

        if loadNewData == true {
            page = 1
        } else {
            page += 1
        }
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.userFollowing(login: login, page: page, per_page: per_page)) { [weak self]result in
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
                        self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                        self.zm_addSubViewModels(cellDatas)
                        self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                        self.tableViewProxy.reloadData()
                        
                    } else {
                        self.zm_addSubViewModels(cellDatas)
                        self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
                        self.tableViewProxy.reloadData()
                    }
                    
                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                    self.endRefreshViews(noMoreData: cellDatas.count < 20)
            
                } else {
                    self.endRefreshViews()
                    self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                    ZLToastView.showMessage(dataStr ?? "", sourceView: self.contentView)
                }
                
            case .failure(let error):
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                ZLToastView.showMessage(error.localizedDescription, sourceView: self.contentView)
            }
        }
    }
}
