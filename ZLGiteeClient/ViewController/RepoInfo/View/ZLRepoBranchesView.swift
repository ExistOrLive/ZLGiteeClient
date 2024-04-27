//
//  ZLRepoBranchesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

class ZLRepoBranchesView: NSObject {

    static func showRepoBranchedView(login: String,
                                     repoName: String,
                                     currentBranch: String,
                                     handle: ((String) -> Void)?) {
        ZLProgressHUD.show()
        
        ZLGiteeRequest.sharedProvider.requestRest(.repoBranchList(login:login ,
                                                                  repoName: repoName,
                                                                  page: 1,
                                                                  per_page: 50)) { result, data, msg in
            ZLProgressHUD.dismiss()
            if result, let branches = data as? [ZLGiteeBranchModel] {
                ZLRepoBranchesView.showWith(currentBranch: currentBranch,
                                            branches: branches,
                                            handle: handle)
            } else {
                ZLToastView.showMessage(msg)
            }
        }
    }

    static func showWith(currentBranch: String,
                         branches: [ZLGiteeBranchModel],
                         handle: ((String) -> Void)?) {
        
        guard let view = ZLMainWindow else { return }
        
        let branchTitles = branches.compactMap{ $0.name ?? "" }
        
        ZMSingleSelectTitlePopView.showCenterSingleSelectTickBox(to: view,
                                                                 title: "分支",
                                                                 selectableTitles: branchTitles,
                                                                 selectedTitle: currentBranch,
                                                                 contentMaxHeight: 320)
        { index, result in
            handle?(result)
        }
    }
}

