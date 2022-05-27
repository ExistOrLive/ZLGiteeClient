//
//  ZLUserTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLUserTableViewCellData: ZLTableViewBaseCellData {

    let userModel: ZLGiteeFollowerModel

    weak var cell: ZLUserTableViewCell?

    init(userModel: ZLGiteeFollowerModel) {
        self.userModel = userModel
        super.init()
    }


    override var cellReuseIdentifier: String {
        "ZLUserTableViewCell"
    }
    
    override var cellHeight: CGFloat {
        UITableView.automaticDimension
    }

    override func onCellSingleTap() {
        
    }
}

extension ZLUserTableViewCellData: ZLUserTableViewCellDelegate {

    func getName() -> String? {
        return self.userModel.name
    }

    func getLoginName() -> String? {
        return self.userModel.login
    }

    func getAvatarUrl() -> String? {
        return self.userModel.avatar_url
    }

    func hasLongPressAction() -> Bool {
        false
    }

    func longPressAction(view: UIView) {
       
    }
}
