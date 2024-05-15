//
//  ZLGiteeEventModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/15.
//

import Foundation
import HandyJSON

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

