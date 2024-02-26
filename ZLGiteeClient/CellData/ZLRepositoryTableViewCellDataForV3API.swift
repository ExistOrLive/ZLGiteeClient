//
//  ZLRepositoryTableViewCellDataV3.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import UIKit
import ZLUIUtilities

class ZLRepositoryTableViewCellDataForV3API: ZLTableViewBaseCellData {
    
    let model: ZLGiteeRepoModelV3
    
    init(model: ZLGiteeRepoModelV3) {
        self.model = model
        super.init()
    }
    
    override var cellReuseIdentifier: String {
        "ZLRepositoryTableViewCell"
    }
    
    override var cellHeight: CGFloat {
        UITableView.automaticDimension
    }
    
    override var cellSwipeActions: UISwipeActionsConfiguration? {
        nil
    }
    
    override func onCellSingleTap() {
        let repoVC = ZLRepoInfoController(repoFullName: model.path_with_namespace ?? "")
        repoVC.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(repoVC, animated: true)
    }
    
    override func clearCache() {
        
    }
}


extension ZLRepositoryTableViewCellDataForV3API: ZLRepositoryTableViewCellDelegate {
    
    func onRepoAvaterClicked() {
        let vc = ZLUserInfoController(login: model.owner?.name ?? "")
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func getOwnerAvatarURL() -> String? {
        model.owner?.new_portrait
    }

    func getRepoFullName() -> String? {
        model.path_with_namespace
    }

    func getRepoName() -> String? {
        model.name
    }

    func getOwnerName() -> String? {
        model.owner?.name
    }

    func getRepoMainLanguage() -> String? {
        model.language
    }

    func getRepoDesc() -> String? {
        model.description
    }

    func isPriva() -> Bool {
        !model.isPublic
    }

    func starNum() -> Int {
        model.stars_count
    }

    func forkNum() -> Int {
        model.forks_count
    }

    func hasLongPressAction() -> Bool {
        false
    }

    func longPressAction(view: UIView) {
        
    }
}


