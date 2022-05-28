//
//  ZLUserInfoController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/28.
//

import UIKit
import ZLBaseUI
import Moya

class ZLUserInfoController: ZLBaseViewController {
    
    // Entry Params
    var login: String?
    
    // model
    var model: ZLGiteeUserModel?
    // viewModel
    var cellDatas: [ZLTableViewBaseCellData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableContainerView.startLoad()
    }
    
    func setupUI() {
        title = login 
        
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func generateCellDatas() {
        cellDatas.removeAll()
        for cellData in cellDatas {
            cellData.removeFromSuperViewModel()
        }
        
        guard let model = model else {
            tableContainerView.resetCellDatas(cellDatas: cellDatas, hasMoreData: false)
            return
        }
        
        let headerCellData = ZLUserInfoHeaderCellData(model: model)
        addSubViewModel(headerCellData)
        cellDatas.append(headerCellData)
        
        if let profession = model.profession, !profession.isEmpty {
            let professionCellData = ZLCommonTableViewCellData(canClick: false, title: "职业", info: profession, cellHeight: 50, actionBlock: nil)
            addSubViewModel(professionCellData)
            cellDatas.append(professionCellData)
        }
        
        if let company = model.company, !company.isEmpty {
            let companyCellData = ZLCommonTableViewCellData(canClick: false, title: "公司", info: company, cellHeight: 50, actionBlock: nil)
            addSubViewModel(companyCellData)
            cellDatas.append(companyCellData)
        }
        
        if let email = model.email, !email.isEmpty {
            let emailCellData = ZLCommonTableViewCellData(canClick: false, title: "邮箱", info: email, cellHeight: 50, actionBlock: nil)
            addSubViewModel(emailCellData)
            cellDatas.append(emailCellData)
        }
        
        if let qq = model.qq, !qq.isEmpty {
            let qqCellData = ZLCommonTableViewCellData(canClick: false, title: "QQ", info: qq, cellHeight: 50, actionBlock: nil)
            addSubViewModel(qqCellData)
            cellDatas.append(qqCellData)
        }
        
        
        if let wechat = model.wechat, !wechat.isEmpty {
            let wechatCellData = ZLCommonTableViewCellData(canClick: false, title: "微信", info: wechat, cellHeight: 50, actionBlock: nil)
            addSubViewModel(wechatCellData)
            cellDatas.append(wechatCellData)
        }
        
        if let linkedin = model.linkedin, !linkedin.isEmpty {
            let linkedinCellData = ZLCommonTableViewCellData(canClick: false, title: "领英", info: linkedin, cellHeight: 50, actionBlock: nil)
            addSubViewModel(linkedinCellData)
            cellDatas.append(linkedinCellData)
        }
        
        if let weibo = model.weibo, !weibo.isEmpty {
            let weiboCellData = ZLCommonTableViewCellData(canClick: false, title: "微博", info: weibo, cellHeight: 50, actionBlock: nil)
            addSubViewModel(weiboCellData)
            cellDatas.append(weiboCellData)
        }
        
        if let blog = model.blog, !blog.isEmpty {
            let blogCellData = ZLCommonTableViewCellData(canClick: false, title: "博客", info: blog, cellHeight: 50, actionBlock: nil)
            addSubViewModel(blogCellData)
            cellDatas.append(blogCellData)
        }
        
        tableContainerView.resetCellDatas(cellDatas: cellDatas, hasMoreData: false)
        
    }
    
    
    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.setTableViewHeader()
        tableView.register(ZLUserInfoHeaderCell.self, forCellReuseIdentifier: "ZLUserInfoHeaderCell")
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.delegate = self
        return tableView
    }()
}

// MARK: ZLTableContainerViewDelegate
extension ZLUserInfoController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        loadRequest()
    }
    
    func zlLoadMoreData() {

    }
}

// MARK: Request
extension ZLUserInfoController {
    
    func loadRequest() {
        
        guard let login = self.login, !login.isEmpty else {
            ZLToastView.showMessage("login为空", sourceView: contentView)
            return
        }
        
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.user(login: login)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let data = response.data
                let dataStr = String(data: data, encoding:.utf8)
                if response.statusCode == 200 {
                    guard let model = ZLGiteeUserModel.deserialize(from: dataStr, designatedPath: nil) else {
                        self.tableContainerView.endRefresh()
                        return
                    }
                    self.model = model
                    self.generateCellDatas()
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
