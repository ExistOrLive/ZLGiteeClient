//
//  ZLFollowEventTableViewData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/22.
//

import ZLUIUtilities
import ZLBaseExtension
import HandyJSON
import ZLUtilities

class ZLFollowEventTableViewData: ZLEventTableViewCellData {
    
    lazy var followPayload: ZLGiteeFollowEventPayloadModel? = {
        ZLGiteeFollowEventPayloadModel.deserialize(from: model.payload)
    }()
    
    override func zm_onCellSingleTap() {
        navigationToTargetVC()
    }

    func navigationToTargetVC() {
        guard let payload = followPayload else { return }
        if payload.target_type == "User", let login = payload.target?.login {
            let vc = ZLUserInfoController(login: login)
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func eventDescription() -> NSAttributedString {
        guard let payload = followPayload else {
            return super.eventDescription()
        }

        if payload.target_type == "User" {
            
            return NSASCContainer(
                "关注了用户 ",
                (payload.target?.name ?? "")
                    .asMutableAttributedString()
                    .yy_highlight(.linkColor(withName: "ZLLinkLabelColor1"),
                                  backgroudColor: .clear,
                                  tapAction: { [weak self] _,_,_,_ in
                                      guard let self else { return }
                                      self.navigationToRepoVC()
                                  })
            ).foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
                .asAttributedString()
        
        } else if payload.target_type == "Group" {
            
            return NSASCContainer(
                "关注了组织 ",
                (payload.target?.name ?? "")
                    .asMutableAttributedString()
                    .yy_highlight(.linkColor(withName: "ZLLinkLabelColor1"),
                                  backgroudColor: .clear,
                                  tapAction: { [weak self] _,_,_,_ in
                                      guard let self else { return }
                                      self.navigationToRepoVC()
                                  })
            ).foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
                .asAttributedString()
    
        } else {
            return super.eventDescription()
        }
    }
}



