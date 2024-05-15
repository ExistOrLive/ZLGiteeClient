//
//  ZLGiteeRepoModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import HandyJSON

// MARK: - Namespace
class ZLGiteeNamespace: HandyJSON{
    required init() {}
    var id: Int = 0
    var type, name, path: String?
    var htmlURL: String?

}

// MARK: - Permission
class ZLGiteePermission: HandyJSON {
    required init() {}
    var pull: Bool = false
    var push: Bool = false
    var admin: Bool = false
}

// MARK: - ZLGiteeRepoBriefModel
class ZLGiteeRepoBriefModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var full_name: String? // 用户名 + 仓库名
    var human_name: String? // 用户名 + 仓库名
    var url: String?
    var namespace: ZLGiteeNamespace? //命名空间
}

// MARK: - ZLGiteeRepoModel
class ZLGiteeRepoModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var full_name: String? // 用户名 + 仓库名
    var human_name: String? // 用户名 + 仓库名
    var url: String?
    var namespace: ZLGiteeNamespace? //命名空间
    var path: String?
    var name: String?
    var owner: ZLGiteeUserBriefModel? // 用户信息
    var assigner: ZLGiteeUserBriefModel?
    var fork: Bool = false
    var html_url: String?
    var recommend: Bool = false
    var gvp: Bool = false
    var description: String?
    var isPrivate: Bool = false
    var isPublic:  Bool = false
    var isInternal: Bool = false
    
    var homepage: String?
    var language: String?
    var forks_count: Int = 0
    var stargazers_count: Int = 0
    var watchers_count: Int = 0
    var default_branch: String?
    var open_issues_count: Int = 0
    var has_issues: Bool = false
    var has_wiki: Bool = false
    var issue_comment: Bool = false
    var can_comment: Bool = false
    var pull_requests_enabled: Bool = false
    var has_page: Bool = false
    var license: String?
    var outsourced: Bool = false
    var project_creator: String?
    var members: [String]?
    var pushed_at: Date?
    var created_at: Date?
    var updated_at: Date?
    var parent: ZLGiteeRepoModel?
    var paas: String?
    var stared: Bool = false
    var watched: Bool = false
    var permission: ZLGiteePermission?
    var relation: String?
    var assignees_number: Int = 0
    var testers_number: Int?
    var assignee: [ZLGiteeUserBriefModel] = []
    var testers: [ZLGiteeUserBriefModel] = []
    var status: String?
    var programs: [String] = []
    var enterprise: String?
    var project_labels: [String] = []
    
    // MARK: ----- ZLGiteeUser 格式转换 -----
    func mapping(mapper: HelpingMapper) {
        mapper <<<
                    self.isPublic <-- "public"
        
        mapper <<<
                    self.isPrivate <-- "private"
        
        mapper <<<
                    self.isInternal <-- "internal"
        mapper <<<
            self.created_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.updated_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.pushed_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")

    }

}




// MARK: - ZLGiteeRepoModelV3
class ZLGiteeUserBriefModelV3: HandyJSON {
    required init() {}
    var id: Int = 0
    var name, username: String?
    var new_portrait: String?
}


class ZLGiteeRepoModelV3: HandyJSON {
    required init() {}
    var id: Int = 0
    var name: String?                 // 仓库名
    var path_with_namespace: String?  // login + 仓库名
    var language: String?
    var forks_count: Int = 0
    var stars_count: Int = 0
    var description: String?
    var owner: ZLGiteeUserBriefModelV3?
    var isPublic: Bool = false
    // MARK: ----- ZLGiteeUser 格式转换 -----
    func mapping(mapper: HelpingMapper) {
        mapper <<<
                    self.isPublic <-- "public"
    }
}


