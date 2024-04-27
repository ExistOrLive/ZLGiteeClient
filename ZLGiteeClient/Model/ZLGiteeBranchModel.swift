//
//  ZLGiteeBranchModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/4/27.
//

import Foundation
import HandyJSON

class ZLGiteeBranchModel: HandyJSON {
    required init() {}
    var name: String?
    var protected: Bool = false
    var protection_url: String?
    var commit: ZLGiteeCommitModel?
}
