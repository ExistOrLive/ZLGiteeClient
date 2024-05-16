//
//  ZLCreateEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/16.
//

import ZLUIUtilities
import ZLBaseExtension
import HandyJSON
import ZLUtilities

/**
 master_branch = "master";
 pusher_type = "user";
 description = "Github客户端 iOS";
 ref_type = "tag";
 ref = "V1.0.1.7";
 */
class ZLCreateEventTableViewCellData: ZLEventTableViewCellData {
    
    lazy var createPayload: ZLGiteeCreateEventPayloadModel? = {
        ZLGiteeCreateEventPayloadModel.deserialize(from: model.payload)
    }()

    override func onCellSingleTap() {
        goRepoVC()
    }

    override func eventDescription() -> NSAttributedString {
        guard let payload = createPayload else {
            return super.eventDescription()
        }

        if payload.ref_type == "repository" {
            
            return NSASCContainer(
                "创建了仓库 ",
                (self.model.repo?.human_name ?? "")
                    .asMutableAttributedString()
                    .yy_highlight(.linkColor(withName: "ZLLinkLabelColor1"),
                                  backgroudColor: .clear,
                                  tapAction: { [weak self] _,_,_,_ in
                                      guard let self else { return }
                                      self.goRepoVC()
                                  })
            ).foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlRegularFont(withSize: 15))
                .asAttributedString()
        
        } else if payload.ref_type == "tag" {
            
            return NSASCContainer(
                "推送了新的标签 ",
                (payload.ref ?? "")
                    .asMutableAttributedString()
                    .yy_highlight(.linkColor(withName: "ZLLinkLabelColor1"),
                                  backgroudColor: .clear,
                                  tapAction: { [weak self] _,_,_,_ in
                                      guard let self else { return }
                                      self.goRepoVC()
                                  }),
                "\n\nin ",
                (model.repo?.human_name ?? "")
                    .asMutableAttributedString()
                    .yy_highlight(.linkColor(withName: "ZLLinkLabelColor1"),
                                  backgroudColor: .clear,
                                  tapAction: { [weak self] _,_,_,_ in
                                      guard let self else { return }
                                      self.goRepoVC()
                                  })
            ).foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlRegularFont(withSize: 15))
                .asAttributedString()
    
        } else if payload.ref_type == "branch" {
            
            return NSASCContainer(
                "推送了新的分支 ",
                (payload.ref ?? "")
                    .asMutableAttributedString()
                    .yy_highlight(.linkColor(withName: "ZLLinkLabelColor1"),
                                  backgroudColor: .clear,
                                  tapAction: { [weak self] _,_,_,_ in
                                      guard let self else { return }
                                      self.goRepoVC()
                                  }),
                "\n\nin ",
                (model.repo?.human_name ?? "")
                    .asMutableAttributedString()
                    .yy_highlight(.linkColor(withName: "ZLLinkLabelColor1"),
                                  backgroudColor: .clear,
                                  tapAction: { [weak self] _,_,_,_ in
                                      guard let self else { return }
                                      self.goRepoVC()
                                  })
            ).foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlRegularFont(withSize: 15))
                .asAttributedString()
        } else {
            return super.eventDescription()
        }
    }
    
    func goRepoVC() {
        let repoVc = ZLRepoInfoController(repoFullName: self.model.repo?.full_name ?? "")
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
}

