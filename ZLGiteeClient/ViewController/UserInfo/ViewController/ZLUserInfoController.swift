//
//  ZLUserInfoController.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/28.
//

import UIKit
import ZLBaseUI
import Moya
import ZLUIUtilities
import ZLUtilities

class ZLUserInfoController: ZLBaseViewController {
    
    // Entry Params
    let login: String
    
    // model
    var model: ZLGiteeUserModel?
    // viewModel
    var sectionDatas: [ZLTableViewBaseSectionData] = []
    
    init(login: String) {
        self.login = login
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableContainerView.startLoad()
        setSharedButton()
    }
    
    func setupUI() {
        title = login 
        
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setSharedButton() {

        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize:30 ),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)

        self.zlNavigationBar.rightButton = button
    }

    // action
    @objc func onMoreButtonClick(button: UIButton) {

        guard let url = URL(string: model?.html_url ?? "") else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }
    
    func generateCellDatas() {
        sectionDatas.removeAll()
        for sectionData in sectionDatas {
            sectionData.removeFromSuperViewModel()
        }
        
        guard let model = model else {
            tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
            return
        }
        
        let headerCellData = ZLUserInfoHeaderCellData(model: model)
        addSubViewModel(headerCellData)
        let headerSectionData = ZLTableViewBaseSectionData(cellDatas: [headerCellData])
        headerSectionData.sectionHeaderViewData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDatas.append(headerSectionData)
        
        var itemCellDatas: [ZLTableViewBaseCellData] = []
        if let profession = model.profession, !profession.isEmpty {
            let professionCellData = ZLCommonTableViewCellData(canClick: false, title: "职业", info: profession, cellHeight: 50, actionBlock: nil)
            addSubViewModel(professionCellData)
            itemCellDatas.append(professionCellData)
        }
        
        if let company = model.company, !company.isEmpty {
            let companyCellData = ZLCommonTableViewCellData(canClick: false, title: "公司", info: company, cellHeight: 50, actionBlock: nil)
            addSubViewModel(companyCellData)
            itemCellDatas.append(companyCellData)
        }
        
        if let email = model.email, !email.isEmpty {
            let emailCellData = ZLCommonTableViewCellData(canClick: false, title: "邮箱", info: email, cellHeight: 50, actionBlock: nil)
            addSubViewModel(emailCellData)
            itemCellDatas.append(emailCellData)
        }
        
        if let qq = model.qq, !qq.isEmpty {
            let qqCellData = ZLCommonTableViewCellData(canClick: false, title: "QQ", info: qq, cellHeight: 50) {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = model.qq
                ZLToastView.showMessage("成功拷贝到剪切板")
            }
            addSubViewModel(qqCellData)
            itemCellDatas.append(qqCellData)
        }
        
        
        if let wechat = model.wechat, !wechat.isEmpty {
            let wechatCellData = ZLCommonTableViewCellData(canClick: false, title: "微信", info: wechat, cellHeight: 50) {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = model.wechat
                ZLToastView.showMessage("成功拷贝到剪切板")
            }
            addSubViewModel(wechatCellData)
            itemCellDatas.append(wechatCellData)
        }
        
        if let linkedin = model.linkedin, !linkedin.isEmpty {
            let linkedinCellData = ZLCommonTableViewCellData(canClick: false, title: "领英", info: linkedin, cellHeight: 50)  {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = model.linkedin
                ZLToastView.showMessage("成功拷贝到剪切板")
            }
            addSubViewModel(linkedinCellData)
            itemCellDatas.append(linkedinCellData)
        }
        
        if let weibo = model.weibo, !weibo.isEmpty {
            let weiboCellData = ZLCommonTableViewCellData(canClick: false, title: "微博", info: weibo, cellHeight: 50, actionBlock: nil)
            addSubViewModel(weiboCellData)
            itemCellDatas.append(weiboCellData)
        }
        
        if let blog = model.blog, !blog.isEmpty {
            let blogCellData = ZLCommonTableViewCellData(canClick: false, title: "博客", info: blog, cellHeight: 50, actionBlock: nil)
            addSubViewModel(blogCellData)
            itemCellDatas.append(blogCellData)
        }
        let itemSectionData = ZLTableViewBaseSectionData(cellDatas: itemCellDatas)
        itemSectionData.sectionHeaderViewData = ZLCommonSectionHeaderFooterViewData(sectionViewHeight: 10)
        sectionDatas.append(itemSectionData)
        
        tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
    }
    
    
    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.setTableViewHeader()
        tableView.register(ZLUserInfoHeaderCell.self, forCellReuseIdentifier: "ZLUserInfoHeaderCell")
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.register(ZLCommonSectionHeaderFooterView.self, forViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
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
        
        guard !login.isEmpty else {
            ZLToastView.showMessage("login 为空", sourceView: contentView)
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
                    self.title = model.name
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
