//
//  ZLCommitCommentEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/28.
//

import ZLUIUtilities
import ZLBaseExtension
import HandyJSON
import ZLUtilities

// CommitCommentEvent
class ZLCommitCommentEventTableViewCellData: ZLEventTableViewCellData {
    

    override var zm_cellReuseIdentifier: String {
        "ZLCommitCommentEventTableViewCell"
    }
    
    lazy var commitCommentPayload: ZLGiteeCommitCommentEventPayloadModel? = {
        ZLGiteeCommitCommentEventPayloadModel.deserialize(from: model.payload)
    }()

    override func eventDescription() -> NSAttributedString {
        guard let payload = commitCommentPayload else {
            return super.eventDescription()
        }
        return NSASCContainer(
            "评论了提交 ".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15)),
            String((payload.comment?.commit_id ?? "").prefix(7))
                .asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLinkLabelColor2"))
                .font(.zlMediumFont(withSize: 15)),
            "\n\n ",
            (payload.comment?.body ?? "")
                .asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor4"))
                .font(.zlRegularFont(withSize: 12))
        ).asAttributedString()
    }
    
    override func zm_onCellSingleTap() {
        guard let url = commitCommentPayload?.comment?.html_url else { return }
        let vc = ZLWebContentController()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL(string: url)
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onRepoButtonClicked() {
        navigationToRepoVC()
    }
    
    func commit_id() -> String {
        return String((commitCommentPayload?.comment?.commit_id ?? "").prefix(7))
    }
    
    func repoHumanName() -> String {
        return commitCommentPayload?.repository?.human_name ?? ""
    }
}


