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

class ZLGiteeRepoModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var full_name: String?
    var human_name: String?
    var url: String?
    var namespace: ZLGiteeNamespace?
    var path: String?
    var name: String?
    var owner: ZLGiteeUserBriefModel?
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
    var open_issues_count: Int?
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
    var pushed_at: String?
    var created_at: String?
    var updated_at: String?
    var parent: String?
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
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
                    self.isPublic <-- "public"
        
        mapper <<<
                    self.isPrivate <-- "private"
        
        mapper <<<
                    self.isInternal <-- "internal"
    }

}







