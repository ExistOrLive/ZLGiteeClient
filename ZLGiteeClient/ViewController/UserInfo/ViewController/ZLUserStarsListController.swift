//
//  ZLUserStarsListController.swift
//  ZLGiteeClient
//
//  Created by ZhangX on 2022/6/2.
//

import UIKit
import ZLBaseUI
import SnapKit
import Moya
import ZLUIUtilities

class ZLUserStarsListController: ZLBaseViewController {

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
        title = "标星"

        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var tableContainerView: ZLTableContainerView =  {
        let tableView = ZLTableContainerView()
        tableView.setTableViewHeader()
        tableView.setTableViewFooter()
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.delegate = self
        return tableView
    }()
}

extension ZLUserStarsListController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        loadData(loadNewData: true)
    }

    func zlLoadMoreData() {
        loadData(loadNewData: false)
    }
}

// request
extension ZLUserStarsListController {
    func loadData(loadNewData: Bool) {

        guard let login = self.login,
           !login.isEmpty else {
            ZLToastView.showMessage("login 为空", sourceView:view)
            tableContainerView.endRefresh()
            return
        }

        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.userStars(login: login)) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let dataStr = String(data: response.data, encoding: .utf8)
                if response.statusCode == 200 {
                    guard let starArray =  [ZLGiteeRepoModel].deserialize(from: dataStr, designatedPath: nil) else {
                        return
                    }
                    let cellDatas: [ZLRepositoryTableViewCellData] =  starArray.compactMap { model in
                        guard let model = model else {
                            return nil
                        }
                        return ZLRepositoryTableViewCellData(model: model)
                    }
                    if loadNewData {
                        for cellData in self.cellDatas {
                            cellData.removeFromSuperViewModel()
                        }
                        self.addSubViewModels(cellDatas)
                        self.cellDatas = cellDatas
                        self.tableContainerView.resetCellDatas(cellDatas: cellDatas, hasMoreData: false)

                    } else {
                        self.addSubViewModels(cellDatas)
                        self.cellDatas.append(contentsOf: cellDatas)
                        self.tableContainerView.resetCellDatas(cellDatas: cellDatas, hasMoreData: false)
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
