//
//  ZLRepositoryTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import ZLUIUtilities

class ZLRepositoryTableViewCellData: ZLTableViewBaseCellData {
    
    let model: ZLGiteeRepoModel
    
    init(model: ZLGiteeRepoModel) {
        self.model = model
        super.init()
        self.cellReuseIdentifier = "ZLRepositoryTableViewCell"
    }
    
    override var cellSwipeActions: UISwipeActionsConfiguration? {
        nil
    }
    
    override func onCellSingleTap() {
        let repoVC = ZLRepoInfoController(repoFullName: model.full_name ?? "")
        repoVC.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(repoVC, animated: true)
    }
    
    override func clearCache() {
        
    }
}


extension ZLRepositoryTableViewCellData: ZLRepositoryTableViewCellDelegate {
    
    func onRepoAvaterClicked() {
        let vc = ZLUserInfoController(login: model.owner?.login ?? "")
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func getOwnerAvatarURL() -> String? {
        model.owner?.avatar_url
    }

    func getRepoFullName() -> String? {
        model.human_name
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
        model.isPrivate
    }

    func starNum() -> Int {
        model.stargazers_count
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

