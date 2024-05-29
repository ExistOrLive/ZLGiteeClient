//
//  ZLPullRequestCommentEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/27.
//

import Foundation
import ZLUtilities
import ZLUIUtilities
import ZLBaseExtension

// PullRequestCommentEvent
class ZLPullRequestCommentEventTableViewCellData: ZLEventTableViewCellData, ZLPullRequstEventTableViewCellDelegate {
    
    override init(model: ZLGiteeEventModel) {
        super.init(model: model)
        cellReuseIdentifier = "ZLPullRequestEventTableViewCell"
    }
    
    lazy var pullRequestCommentPayload: ZLGiteePullRequestCommentEventPayloadModel? = {
        ZLGiteePullRequestCommentEventPayloadModel.deserialize(from: model.payload)
    }()

    override func eventDescription() -> NSAttributedString {
        return NSASCContainer(
            "评论了 pull request\n\n  ".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15)),
            (pullRequestCommentPayload?.comment?.body ?? "")
                .asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor4"))
                .font(.zlRegularFont(withSize: 12))
        ).asAttributedString()
    }
    
    override func onCellSingleTap() {
        guard let url = pullRequestCommentPayload?.pull_request?.html_url else { return }
        let vc = ZLWebContentController()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL(string: url)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pullRequestNumber() -> String {
        "\(pullRequestCommentPayload?.pull_request?.number ?? 0)"
    }
    
    func pullRequestState() -> String {
        pullRequestCommentPayload?.pull_request?.state ?? ""
    }
    
    func pullRequesTitle() -> String {
        pullRequestCommentPayload?.pull_request?.title ?? ""
    }
    
    func pullRequestBase() -> String {
        guard let base = pullRequestCommentPayload?.pull_request?.base else { return ""}
        return "\(base.repo?.human_name ?? "") : \(base.ref ?? "")"
    }
    
    func pullRequestHead() -> String {
        guard let head = pullRequestCommentPayload?.pull_request?.head else { return ""}
        return "\(head.repo?.human_name ?? "") : \(head.ref ?? "")"
    }
    
    func onPullRequestBaseRepoClicked() {
        guard let fullName = pullRequestCommentPayload?.pull_request?.base?.repo?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: fullName)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func onPullRequestHeadRepoClicked() {
        guard let fullName = pullRequestCommentPayload?.pull_request?.head?.repo?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: fullName)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
   
}

