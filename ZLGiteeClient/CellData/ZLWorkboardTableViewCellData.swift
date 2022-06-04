//
//  ZLWorkboardTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by ZhangX on 2022/6/4.
//

import UIKit
import ZLBaseUI

class ZLWorkboardTableViewCellData: ZLBaseViewModel, ZLWorkboardTableViewCellDelegate {
    
    private let celltitle: String
    private let cellavatarURL: String
    private let type: ZLWorkboardType

    init(title: String = "", avatarURL: String = "", type: ZLWorkboardType) {
        self.type = type
        self.celltitle = title
        self.cellavatarURL = avatarURL
        super.init()
    }

    var title: String {
        get {
            switch type {
            case .issues:
                return "问题"
            case .pullRequest:
                return  "拉取请求"
            case .repos:
                return  "仓库"
            case .orgs:
                return  "组织"
            case .starRepos:
                return "标星"
            case .events:
                return "动态"
            case .fixRepo:
                return self.celltitle
            }

        }
    }

    var avatarURL: String {
        get {
            switch type {
            case .issues:
                return "issues_icon"
            case .pullRequest:
                return "pr_icon"
            case .repos:
                return "repo_icon"
            case .orgs:
                return "org_icon"
            case .starRepos:
                return "star_icon"
            case .events:
                return "event_icon"
            case .fixRepo:
                return self.cellavatarURL
            }
        }
    }

    func onCellClicked() {
        
    }
        
}
