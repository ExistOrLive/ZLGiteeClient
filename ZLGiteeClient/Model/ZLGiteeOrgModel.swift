//
//  ZLGiteeOrgModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/28.
//

import Foundation
import HandyJSON

// MARK: ----- ZLGiteeOrgModel -----
class ZLGiteeOrgModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var login, name: String?
    var avatar_url: String?
    var description: String?
    var follow_count: Int = 0
}
