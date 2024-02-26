//
//  ZLGiteeIssueModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import Foundation
import HandyJSON

class ZLGiteeLabelModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var color: String?
    var name: String?
    var repository_id: Int = 0
    var url: String?
    var updated_at: Date?                     // 更新时间
    var created_at: Date?                     // 创建时间
   
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.created_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.updated_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
}

class ZLGiteeIssueModel: HandyJSON {
    required init() {}
    
    var id: Int = 0
    var number: String?                             // 唯一标识
    var url: String?                                // url
    var html_url: String?                                // url
    var state: String?                              // 状态 open progressing closed rejected all 
    var priority: Int = 0                           // 优先级(0: 不指定 1: 不重要 2: 次要 3: 主要 4: 严重)
    var title: String?                              // 标题
    var body: String?                               // 内容
    var comments: Int = 0                           // 评论数量
    var user: ZLGiteeUserModel?                     // 创建者
    var repository: ZLGiteeRepoModel?               // 所属仓库
    var assignee: ZLGiteeUserModel?                 // 负责人
    var collaborators: [ZLGiteeUserModel] = []      // 协作者
    var security_hole: Bool = false                 // 是否为私有
    var updated_at: Date?                           // 更新时间
    var created_at: Date?                           // 创建时间
    var labels: [ZLGiteeLabelModel] = []            // label
   
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.created_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.updated_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
    
}
