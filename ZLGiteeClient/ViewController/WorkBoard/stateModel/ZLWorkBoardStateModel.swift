//
//  ZLWorkBoardStateModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/7/24.
//

import Foundation


class ZLWorkBoardStateModel: NSObject {
    
    private(set) var userModel: ZLGiteeUserBriefModel?
    
    override init() {
        super.init()
        userModel = ZLGiteeOAuthUserServiceModel.sharedService.currentUserModel
    }
}
