//
//  ZLUserStarsListController.swift
//  ZLGiteeClient
//
//  Created by ZhangX on 2022/6/2.
//

import UIKit
import SnapKit
import Moya
import ZLUIUtilities
import ZMMVVM

class ZLUserStarsListController: ZMTableViewController {

    // Entry Params
    var login: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        loadData(loadNewData: true)
    }

    override func setupUI() {
        super.setupUI()
        title = "标星"
        setRefreshView(type: .header)
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
        
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(loadNewData: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(loadNewData: false)
    }
}

// request
extension ZLUserStarsListController {
    func loadData(loadNewData: Bool) {
        
        let provider = MoyaProvider<ZLGiteeRequest>()
        provider.request(ZLGiteeRequest.userStars(login: login)) { [weak self]result in
            guard let self = self else { return }
            self.viewStatus = .normal
            self.endRefreshView(type: .header)
            self.endRefreshView(type: .footer)
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
                    self.zm_addSubViewModels(cellDatas)
                    if loadNewData {
                        for sectionData in self.sectionDataArray {
                            sectionData.zm_removeFromSuperViewModel()
                        }
                        let newSectionData = ZMBaseTableViewSectionData(zm_sectionID: "",
                                                                        cellDatas: cellDatas)
                        self.sectionDataArray = [ZMBaseTableViewSectionData(zm_sectionID: "",
                                                                            cellDatas: cellDatas)]
                    } else {
                        self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
                    }
                    self.tableViewProxy.reloadData()
                    self.viewStatus = (self.sectionDataArray.first?.cellDatas.isEmpty ?? true) ? .empty : .normal
                } else {
                    self.viewStatus = (self.sectionDataArray.first?.cellDatas.isEmpty ?? true)  ? .error : .normal
                    ZLToastView.showMessage(dataStr ?? "", sourceView: self.contentView)
                }

            case .failure(let error):
                self.viewStatus = (self.sectionDataArray.first?.cellDatas.isEmpty ?? true)  ? .error : .normal
                ZLToastView.showMessage(error.localizedDescription, sourceView: self.contentView)
            }
        }
    }
}
