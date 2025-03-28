//
//  ZLRepoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/6/4.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import ZMMVVM

class ZLRepoHeaderCellData: ZMBaseTableViewCellViewModel {
    
    // presenter
    let stateModel: ZLRepoInfoStateModel
    
    init(stateModel: ZLRepoInfoStateModel) {
        self.stateModel = stateModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLRepoInfoHeaderCell"
    }
}


// MARK: - ZLRepoInfoHeaderCellDataSourceAndDelegate
extension ZLRepoHeaderCellData: ZLRepoInfoHeaderCellDataSourceAndDelegate {
    
    var repoInfoModel: ZLGiteeRepoModel? {
        stateModel.repoInfo
    }
    
    var avatarUrl: String {
        repoInfoModel?.owner?.avatar_url ?? ""
    }
    var repoName: String {
        repoInfoModel?.full_name ?? ""
    }
    
    var repoHumanName: String {
        repoInfoModel?.human_name ?? ""
    }
    
    var sourceRepoName: String? {
        repoInfoModel?.parent?.full_name
    }
    
    var sourceRepoHumanName: String? {
        repoInfoModel?.parent?.human_name
    }
    
    var updatedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let updated_at = repoInfoModel?.updated_at {
            let time = dateFormatter.string(from: updated_at)
            let createdAtStr = "更新于"
            return "\(createdAtStr) \((time))"
        } else if let created_at = repoInfoModel?.created_at {
            let time = dateFormatter.string(from: created_at)
            let createdAtStr = "创建于"
            return "\(createdAtStr) \((time))"
        }
        return ""
    }
    
    var desc: String {
        repoInfoModel?.description ?? ""
    }
    
    var issueNum: Int {
        repoInfoModel?.open_issues_count ?? 0
    }

    var starsNum: Int {
        repoInfoModel?.stargazers_count ?? 0
    }

    var forksNum: Int {
        repoInfoModel?.forks_count ?? 0
    }

    var watchersNum: Int {
        repoInfoModel?.watchers_count ?? 0
    }
    
    var watched: Bool {
        stateModel.viewerIsWatch
    }
    var starred: Bool {
        stateModel.viewerIsStar
    }
    
    func onAvatarButtonClicked() {
        let userInfoVC = ZLUserInfoController(login: repoInfoModel?.owner?.login ?? "")
        zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    func onStarButtonClicked() {
        ZLProgressHUD.show(view: zm_viewController?.view, animated: true)
        stateModel.starRepo { [weak self] result, msg in
            guard let self else { return }
            ZLProgressHUD.dismiss(view: self.zm_viewController?.view, animated: true)
            if result {
                ZLToastView.showMessage(self.stateModel.viewerIsStar ? "star成功" : "取消star成功", sourceView: self.zm_viewController?.view)
            } else {
                ZLToastView.showMessage(msg, sourceView: self.zm_viewController?.view)
            }
        }
    }
    
    func onForkButtonClicked() {
        ZLProgressHUD.show(view: zm_viewController?.view, animated: true)
        stateModel.forkRepo { [weak self] result, model, msg in
            guard let self = self else { return }
            ZLProgressHUD.dismiss(view: self.zm_viewController?.view, animated: true)
            if result, let model {
                let repoInfoVC = ZLRepoInfoController(repoFullName: model.full_name ?? "")
                self.zm_viewController?.navigationController?.pushViewController(repoInfoVC, animated: true)
                ZLToastView.showMessage("fork成功")
            } else {
                ZLToastView.showMessage(msg, sourceView: self.zm_viewController?.view)
            }
        }
    }
    
    func onWatchButtonClicked() {
        ZLProgressHUD.show(view: zm_viewController?.view, animated: true)
        stateModel.watchRepo { [weak self] result, msg in
            guard let self else { return }
            ZLProgressHUD.dismiss(view: self.zm_viewController?.view, animated: true)
            if result {
                ZLToastView.showMessage(self.stateModel.viewerIsWatch ? "watch成功" : "取消watch成功", sourceView: self.zm_viewController?.view)
            } else {
                ZLToastView.showMessage(msg, sourceView: self.zm_viewController?.view)
            }
        }
    }

    func onIssuesNumButtonClicked() {
        let vc = ZLRepoIssueListController(repoFullName: repoInfoModel?.full_name ?? "")
        self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStarsNumButtonClicked() {
        let vc = ZLRepoStarsListController(repoFullName: repoInfoModel?.full_name ?? "")
        self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onForksNumButtonClicked() {
        let vc = ZLRepoForksListController(repoFullName: repoInfoModel?.full_name ?? "")
        self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onWatchersNumButtonClicked() {
        let vc = ZLRepoWatchingListController(repoFullName: repoInfoModel?.full_name ?? "")
        self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onSourceRepoClicked() {
        if let repoFullName = sourceRepoName {
            let vc = ZLRepoInfoController(repoFullName: repoFullName) 
            self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
