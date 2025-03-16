//
//  ZLUserInfoController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/28.
//

import UIKit
import Moya
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

class ZLUserInfoController: ZMTableViewController {
    
    // Entry Params
    let login: String
    
    // model
    var model: ZLGiteeUserModel?

    
    init(login: String) {
        self.login = login
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    // MARK: - UI
    override func setupUI() {
        super.setupUI()
        title = login
        setSharedButton()
        
        setRefreshViews(types: [.header])
        tableView.register(ZLUserInfoHeaderCell.self, forCellReuseIdentifier: "ZLUserInfoHeaderCell")
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.register(ZLCommonSectionHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
    }
    
    func setSharedButton() {

        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize:30 ),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)

        self.zmNavigationBar.addSubview(button)
    }
    
    // MARK: - ZLRefreshProtocol
    override func refreshLoadNewData()  {
        loadData()
    }

    // MARK: - action
    @objc func onMoreButtonClick(button: UIButton) {

        guard let url = URL(string: model?.html_url ?? "") else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }
    
    // MARK: - cell Data
    func generateCellDatas() {
    
        guard let model = model else {
            return
        }
        
        sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
        sectionDataArray.removeAll()
        
        // header
        let headerSectionData = ZMBaseTableViewSectionData()
        headerSectionData.cellDatas = [ZLUserInfoHeaderCellData(model: model)]
        headerSectionData.headerData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDataArray.append(headerSectionData)
        
        // item 
        var itemCellDatas: [ZMBaseTableViewCellViewModel] = []
        if let profession = model.profession, !profession.isEmpty {
            let professionCellData = ZLCommonTableViewCellData(canClick: false, title: "职业", info: profession, cellHeight: 50, actionBlock: nil)
            itemCellDatas.append(professionCellData)
        }
        
        if let company = model.company, !company.isEmpty {
            let companyCellData = ZLCommonTableViewCellData(canClick: false, title: "公司", info: company, cellHeight: 50, actionBlock: nil)
            itemCellDatas.append(companyCellData)
        }
        
        if let email = model.email, !email.isEmpty {
            let emailCellData = ZLCommonTableViewCellData(canClick: false, title: "邮箱", info: email, cellHeight: 50, actionBlock: nil)
            itemCellDatas.append(emailCellData)
        }
        
        if let qq = model.qq, !qq.isEmpty {
            let qqCellData = ZLCommonTableViewCellData(canClick: false, title: "QQ", info: qq, cellHeight: 50) {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = model.qq
                ZLToastView.showMessage("成功拷贝到剪切板")
            }
            itemCellDatas.append(qqCellData)
        }
        
        
        if let wechat = model.wechat, !wechat.isEmpty {
            let wechatCellData = ZLCommonTableViewCellData(canClick: false, title: "微信", info: wechat, cellHeight: 50) {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = model.wechat
                ZLToastView.showMessage("成功拷贝到剪切板")
            }
            itemCellDatas.append(wechatCellData)
        }
        
        if let linkedin = model.linkedin, !linkedin.isEmpty {
            let linkedinCellData = ZLCommonTableViewCellData(canClick: false, title: "领英", info: linkedin, cellHeight: 50)  {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = model.linkedin
                ZLToastView.showMessage("成功拷贝到剪切板")
            }
            itemCellDatas.append(linkedinCellData)
        }
        
        if let weibo = model.weibo, !weibo.isEmpty {
            let weiboCellData = ZLCommonTableViewCellData(canClick: false, title: "微博", info: weibo, cellHeight: 50, actionBlock: nil)
            itemCellDatas.append(weiboCellData)
        }
        
        if let blog = model.blog, !blog.isEmpty {
            let blogCellData = ZLCommonTableViewCellData(canClick: false, title: "博客", info: blog, cellHeight: 50, actionBlock: nil)
            itemCellDatas.append(blogCellData)
        }
        let itemSectionData = ZMBaseTableViewSectionData(cellDatas: itemCellDatas)
        itemSectionData.headerData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDataArray.append(itemSectionData)
        
        sectionDataArray.forEach { $0.zm_addSuperViewModel(self) }
    }
    
   
}


// MARK: Request
extension ZLUserInfoController {
    
    func loadData() {
        guard !login.isEmpty else {
            ZLToastView.showMessage("login 为空", sourceView: contentView)
            self.viewStatus = .normal
            self.endRefreshView(type: .header)
            return
        }
        
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.user(login: login)) { [weak self] result in
            guard let self = self else { return }
            self.endRefreshView(type: .header)
            switch result {
            case .success(let response):
                let data = response.data
                let dataStr = String(data: data, encoding:.utf8)
                if response.statusCode == 200 {
                    guard let model = ZLGiteeUserModel.deserialize(from: dataStr, designatedPath: nil) else {
                        self.viewStatus = self.model == nil ? .error : .normal
                        return
                    }
                    self.model = model
                    self.title = model.name
                    self.generateCellDatas()
                    self.tableView.reloadData()
                    self.viewStatus = .normal
                } else {
                    self.viewStatus = self.model == nil ? .error : .normal
                    ZLToastView.showMessage(dataStr ?? "", sourceView: self.contentView)
                }
            case .failure(let error):
                self.viewStatus = self.model == nil ? .error : .normal
                ZLToastView.showMessage(error.localizedDescription, sourceView: self.contentView)
            }
        
        }
    }
}
