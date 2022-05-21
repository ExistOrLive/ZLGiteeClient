//
//  ZLRepositoryTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit

class ZLRepositoryTableViewCellData: ZLTableViewBaseCellData {
    
    let model: ZLGiteeRepoModel
    
    init(model: ZLGiteeRepoModel) {
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
        
    }
    
    override func clearCache() {
        
    }
}


extension ZLRepositoryTableViewCellData: ZLRepositoryTableViewCellDelegate {
    
    func onRepoAvaterClicked() {
        
    }

    func getOwnerAvatarURL() -> String? {
        model.owner?.avatar_url
    }

    func getRepoFullName() -> String? {
        model.full_name
    }

    func getRepoName() -> String? {
        model.name
    }

    func getOwnerName() -> String? {
        model.owner?.login
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

