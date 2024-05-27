//
//  ZLGiteePullRequestModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/27.
//

import Foundation
import HandyJSON

class ZLGiteePullRequestRefModel: HandyJSON {
    required init() {}
    var label: String?
    var ref: String?
    var sha: String?
    var user: ZLGiteeUserModel?
    var repo: ZLGiteeRepoModel?
}


class ZLGiteePullRequestModel: HandyJSON {
    required init() {}
    
    var id: Int = 0
    var number: Int = 0                              // number
    var url: String?                                // url
    var html_url: String?                                // url
    var state: String?                              // 状态 open / closed / merged
   
    var title: String?                              // 标题
    var body: String?                               // 内容
    var user: ZLGiteeUserModel?                     // 创建者
    
    var assignees: [ZLGiteeUserModel] = []          // 被分配的人员
    var assignees_number: Int = 0
    
    var draft: Bool = false                         // 是否为草稿
    var locked: Bool = false                        // 是否锁定
    var mergeable: Bool = false                     // 是否可以合并

    var updated_at: Date?                           // 更新时间
    var created_at: Date?                           // 创建时间
    var merged_at: Date?                            // 合并时间
    var closed_at: Date?                            // 关闭时间
    var labels: [ZLGiteeLabelModel] = []            // label
    
    
    var head: ZLGiteePullRequestRefModel?
    var base: ZLGiteePullRequestRefModel?           // head -> base
   
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.created_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.updated_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.merged_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.closed_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
    
}
