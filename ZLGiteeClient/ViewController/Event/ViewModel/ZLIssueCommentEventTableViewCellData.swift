//
//  ZLIssueCommentEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/22.
//

import Foundation
import ZLUtilities
import ZLUIUtilities
import ZLBaseExtension

class ZLIssueCommentEventTableViewCellData: ZLEventTableViewCellData, ZLIssueEventTableViewCellDelegate {
    
    override var zm_cellReuseIdentifier: String {
        "ZLIssueEventTableViewCell"
    }
    
    
    lazy var issueCommentPayload: ZLGiteeIssueCommentEventPayloadModel? = {
        ZLGiteeIssueCommentEventPayloadModel.deserialize(from: model.payload)
    }()

    override func eventDescription() -> NSAttributedString {
        return NSASCContainer(
            "评论了任务\n\n  ".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15)),
            (issueCommentPayload?.comment?.body ?? "")
                .asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor4"))
                .font(.zlRegularFont(withSize: 12))
        ).asAttributedString()
    }
    
    // MARK: - Action
    override func navigationToRepoVC() {
        guard let full_name = issueCommentPayload?.repository?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: full_name)
        repoVc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    override func zm_onCellSingleTap () {
        guard let url = issueCommentPayload?.issue?.html_url else { return }
        let vc = ZLWebContentController()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL(string: url)
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

    func issueId() -> String {
        return issueCommentPayload?.issue?.number ?? ""
    }
    
    func issueTitle() -> String {
        return issueCommentPayload?.issue?.title ?? ""
    }
    
    func issueRepoHumanName() -> String {
        return issueCommentPayload?.repository?.human_name ?? ""
    }
    
    func onIssueRepoClicked() {
        navigationToRepoVC()
    }
   
}
