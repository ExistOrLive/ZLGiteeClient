//
//  ZLGiteeFollowerModel.swift
//  ZLGiteeClient
//
//  Created by ZhangX on 2022/5/21.
//

import UIKit
import HandyJSON

class ZLGiteeFollowerModel: HandyJSON {
    
    required init() {}
    
    var id: Int = 0
    var login: String?
    var name: String?
    var avatar_url: String?
    var html_url: String?
    var url: String?
    var remark: String?
    
    var followers_url: String?
    var following_url: String?
    var gists_url: String?
    var starred_url: String?
    var subscriptions_url: String?
    var organizations_url: String?
    var repos_url: String?
    var events_url:String?
    var received_events_url:String?
    var type:String?
    
}
