//
//  ZLGiteeUserModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import HandyJSON

// MARK: ----- ZLGiteeUserBriefModel -----
class ZLGiteeUserBriefModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var login, name: String?
    var avatar_url: String?
    var url, html_url: String?
    var remark: String?
    var type: String?
}

// MARK: ----- ZLGiteeUserModel -----
class ZLGiteeUserModel: HandyJSON {
    
    required init() {}
    
    var id: Int = 0
    var login: String?
    var name: String?
    var avatar_url: String?
    var html_url: String?
    var url: String?
    var remark: String?
    
    var type: String?
    var blog: String?
    var weibo: String?
    var company: String?
    var bio: String?
    var profession: String?
    var email: String?
    var wechat: String?
    var qq: String?
    var linkedin: String?

    var followers: Int = 0
    var following: Int = 0
    var stared: Int = 0
    var watched: Int = 0
    var public_repos: Int = 0
    var public_gists: Int = 0
    
    var created_at: Date?
    var updated_at: Date?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.created_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        mapper <<<
            self.updated_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
}
