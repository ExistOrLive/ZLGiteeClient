//
//  ZLGiteeCommitModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/3.
//

import Foundation
import HandyJSON

class ZLGiteeCommitModel: HandyJSON {
    required init() {}
    
    var url: String?
    var sha: String?
    var html_url: String?
    var comments_url: String?
    var commit: ZLGiteeCommitMessageModel?
    var author: ZLGiteeUserModel?
    var committer: ZLGiteeUserModel?
    var parents: [ZLGiteeCommitTreeModel] = []
}

class ZLGiteeCommitUserModel: HandyJSON {
    required init() {}
    
    var name: String?
    var date: Date?
    var email: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
}

class ZLGiteeCommitMessageModel: HandyJSON {
    required init() {}
    
    var message: String?
    var tree: ZLGiteeCommitTreeModel?
    var author: ZLGiteeCommitUserModel?
    var committer: ZLGiteeCommitUserModel?
}

class ZLGiteeCommitTreeModel: HandyJSON {
    required init() {}
    
    var url: String?
    var sha: String?
}


