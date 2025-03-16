//
//  ZLUserFollowerListController.swift
//  ZLGiteeClient
//
//  Created by ZhangX on 2022/5/21.
//

import UIKit
import SnapKit
import Moya
import ZLUIUtilities
import ZMMVVM

class ZLUserFollowerListController: ZMTableViewController {
    
    // Entry Params
    var login: String?
    
    private var page: Int = 1
    private var per_page: Int = 20
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "粉丝"
        setRefreshView(type: .header)
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
        
        tableView.register(ZLUserTableViewCell.self, forCellReuseIdentifier: "ZLUserTableViewCell")
    }

    override func refreshLoadNewData() {
        guard let login = self.login,
           !login.isEmpty else {
            ZLToastView.showMessage("login 为空", sourceView:view)
            endRefreshView(type: .header)
            return
        }
        
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.userFollower(login: login, page: 1, per_page: per_page)) { [weak self]result in
            guard let self = self else { return }
            self.endRefreshView(type: .header)
            switch result {
            case .success(let response):
                let dataStr = String(data: response.data, encoding: .utf8)
                if response.statusCode == 200 {
                    guard let followerArray =  [ZLGiteeUserModel].deserialize(from: dataStr, designatedPath: nil) else {
                        return
                    }
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    let cellDatas: [ZLUserTableViewCellData] =  followerArray.compactMap { model in
                        guard let model = model else {
                            return nil
                        }
                        return ZLUserTableViewCellData(userModel: model)
                    }
             
                    self.zm_addSubViewModels(cellDatas)
                    let sectionData = ZMBaseTableViewSectionData(zm_sectionID: "", cellDatas: cellDatas)
                    self.sectionDataArray = [sectionData]
                    self.tableViewProxy.reloadData()
                    self.viewStatus = cellDatas.isEmpty ? .empty : .normal
                    self.page = 2
                } else {
                    self.viewStatus = self.sectionDataArray.first?.cellDatas.isEmpty ?? true ? .error : .normal
                    ZLToastView.showMessage(dataStr ?? "", sourceView: self.contentView)
                }
                
            case .failure(let error):
                self.viewStatus = self.sectionDataArray.first?.cellDatas.isEmpty ?? true ? .error : .normal
                ZLToastView.showMessage(error.localizedDescription, sourceView: self.contentView)
            }
        }
    }
    
    override func refreshLoadMoreData() {
        guard let login = self.login,
           !login.isEmpty else {
            ZLToastView.showMessage("login 为空", sourceView:view)
            endRefreshView(type: .footer)
            return
        }
        
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.userFollower(login: login, page: page + 1, per_page: per_page)) { [weak self]result in
            guard let self = self else { return }
            self.endRefreshView(type: .footer)
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
                    self.zm_addSubViewModels(cellDatas)
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
                    self.tableViewProxy.reloadData()
                    self.page = self.page + 1
                } else {
                    ZLToastView.showMessage(dataStr ?? "", sourceView: self.contentView)
                }
                
            case .failure(let error):
                ZLToastView.showMessage(error.localizedDescription, sourceView: self.contentView)
            }
        }
    }
}
