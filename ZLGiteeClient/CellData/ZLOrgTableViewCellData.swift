//
//  ZLOrgTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/28.
//

import Foundation
import ZLBaseUI
import ZLUIUtilities

class ZLOrgTableViewCellData: ZLTableViewBaseCellData {

    let orgModel: ZLGiteeOrgModel

     init(orgModel: ZLGiteeOrgModel) {
         self.orgModel = orgModel
         super.init()
         self.cellReuseIdentifier = "ZLOrgTableViewCell"
     }
 
    override func onCellSingleTap() {
    
    }
}

extension ZLOrgTableViewCellData: ZLOrgTableViewCellDelegate {
   
    func getName() -> String? {
        orgModel.name
    }

    func getLoginName() -> String? {
        orgModel.login
    }

    func getAvatarUrl() -> String? {
        orgModel.avatar_url
    }

    func desc() -> String? {
        orgModel.description
    }
    
    func followCount() -> Int {
        orgModel.follow_count
    }

    func hasLongPressAction() -> Bool {
        false
    }

    func longPressAction(view: UIView) {
        
    }
}



