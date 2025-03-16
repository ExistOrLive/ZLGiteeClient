//
//  ZLRepositoryTableViewCellDataV3.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import UIKit
import ZMMVVM
import ZLUIUtilities

class ZLRepositoryTableViewCellDataForV3API: ZMBaseTableViewCellViewModel {
    
    let model: ZLGiteeRepoModelV3
    
    init(model: ZLGiteeRepoModelV3) {
        self.model = model
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLRepositoryTableViewCell"
    }

    override func zm_onCellSingleTap() {
        let repoVC = ZLRepoInfoController(repoFullName: model.path_with_namespace ?? "")
        repoVC.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(repoVC, animated: true)
    }
}


extension ZLRepositoryTableViewCellDataForV3API: ZLRepositoryTableViewCellDelegate {
    
    func onRepoAvaterClicked() {
        let vc = ZLUserInfoController(login: model.owner?.name ?? "")
        vc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
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


