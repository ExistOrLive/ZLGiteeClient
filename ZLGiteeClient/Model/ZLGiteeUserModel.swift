//
//  ZLGiteeUserModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import UIKit
import HandyJSON

class ZLGiteeUserBriefModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var login, name: String?
    var avatar_url: String?
    var url, html_url: String?
    var remark: String?
    var type: String?
}


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
}
