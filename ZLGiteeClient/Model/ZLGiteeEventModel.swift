//
//  ZLGiteeEventModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/15.
//

import Foundation
import HandyJSON

// MARK: - ZLGiteeEventModel
class ZLGiteeEventModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var type: String?                   /// 事件类型
    var isPublic: Bool = false
    var created_at: Date? 
    var actor: ZLGiteeUserBriefModel?
    var org: ZLGiteeOrgModel?
    var repo: ZLGiteeRepoBriefModel?
    var payload: [String:Any]?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
                    self.isPublic <-- "public"
        mapper <<<
            self.created_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
}

// MARK: - ZLGiteeCreateEventPayloadModel
class ZLGiteeCreateEventPayloadModel: HandyJSON {
    required init() {}
    var ref_type: String?          /// repository/tag/branch
    var ref: String?               ///  分支/标签
    var default_branch: String?    /// 默认分支
    var description: String?
}

// MARK: - ZLGiteePushEventPayloadModel
class ZLGiteePushEventPayloadModel: HandyJSON {
    required init() {}
    var ref: String?            /// 分支
    var before: String?         /// 推送前的commit
    var after: String?          /// 推送后的commit
    var created: Bool = false
    var deleted: Bool = false
    var size: Int = 0
    var commits: [ZLGiteePushEventCommitModel] = [] /// commit
}

class ZLGiteePushEventCommitModel: HandyJSON {
    required init() {}
    var sha: String?            /// sha
    var message: String?        /// commit的message
    var url: String?            /// 推送后的commit
    var author: ZLGiteePushEventCommitAuthorModel? /// author
}

class ZLGiteePushEventCommitAuthorModel: HandyJSON {
    required init() {}
    var email: String?         /// 邮箱
    var name: String?          /// author name
}

// MARK: - ZLGiteeFollowEventPayloadModel
class ZLGiteeFollowEventPayloadModel: HandyJSON {
    required init() {}
    var target: ZLGiteeFollowEventTargetModel? 
    var target_type: String?      /// User / Group
    var followed: Bool = false    /// followed
}

class ZLGiteeFollowEventTargetModel: HandyJSON {
    required init() {}

    var id: String?
    var login: String?
    var name: String?
    var avatar_url: String?
    var url: String?
    var html_url: String?
    var remark: String?
}
