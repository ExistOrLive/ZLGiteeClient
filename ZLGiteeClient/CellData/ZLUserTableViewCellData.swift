//
//  ZLUserTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLUserTableViewCellData: ZLTableViewBaseCellData {

    let userModel: ZLGiteeUserModel

    weak var cell: ZLUserTableViewCell?

    init(userModel: ZLGiteeUserModel) {
        self.userModel = userModel
        super.init()
        self.cellReuseIdentifier = "ZLUserTableViewCell"
    }

    override func onCellSingleTap() {
        let vc = ZLUserInfoController(login: userModel.login ?? "")
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
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
