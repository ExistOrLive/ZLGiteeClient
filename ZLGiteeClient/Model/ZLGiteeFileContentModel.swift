//
//  ZLGiteeFileContentModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/4/11.
//

import Foundation
import HandyJSON

// MARK: ----- ZLGiteeOrgModel -----
class ZLGiteeFileContentModel: HandyJSON {
    required init() {}
    var type: String = "file"        // file dir
    var encoding: String = "base64"
    var size: Int = 0
    var name: String = ""
    var path: String = ""
    var content: String = ""
    var sha: String = ""
    var html_url: String = ""
    var download_url: String = ""
}
