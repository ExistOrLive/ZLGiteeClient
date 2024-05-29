//
//  ZLPullRequestEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/27.
//

import Foundation
import ZLUtilities
import ZLUIUtilities
import ZLBaseExtension

// PullRequestEvent
class ZLPullRequestEventTableViewCellData: ZLEventTableViewCellData, ZLPullRequstEventTableViewCellDelegate {
  
    override init(model: ZLGiteeEventModel) {
        super.init(model: model)
        cellReuseIdentifier = "ZLPullRequestEventTableViewCell"
    }
    
    lazy var pullRequestPayload: ZLGiteePullRequestEventPayloadModel? = {
        ZLGiteePullRequestEventPayloadModel.deserialize(from: model.payload)
    }()

    ///
    override func eventDescription() -> NSAttributedString {
        guard let pullRequestPayload,
              let action = pullRequestPayload.action else { return super.eventDescription() }
        // opened / closed / reopened/ merged
        switch action {
        case "opened":
            return  "创建了新的 pull request".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
        case "closed":
            return  "关闭了 pull request".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
        case "reopened":
            return  "重新打开 pull request".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
        case "merged":
            return  "接受了 pull request".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
        default:
            return super.eventDescription()
        }
    }
    
    override func onCellSingleTap() {
        guard let url = pullRequestPayload?.html_url else { return }
        let vc = ZLWebContentController()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL(string: url)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pullRequestNumber() -> String {
        "\(pullRequestPayload?.number ?? 0)"
    }
    
    func pullRequestState() -> String {
        pullRequestPayload?.state ?? ""
    }
    
    func pullRequesTitle() -> String {
        pullRequestPayload?.title ?? ""
    }
    
    func pullRequestBase() -> String {
        guard let base = pullRequestPayload?.base else { return ""}
        return "\(base.repo?.human_name ?? "") : \(base.ref ?? "")"
    }
    
    func pullRequestHead() -> String {
        guard let head = pullRequestPayload?.head else { return ""}
        return "\(head.repo?.human_name ?? "") : \(head.ref ?? "")"
    }
    
    func onPullRequestBaseRepoClicked() {
        guard let fullName = pullRequestPayload?.base?.repo?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: fullName)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func onPullRequestHeadRepoClicked() {
        guard let fullName = pullRequestPayload?.head?.repo?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: fullName)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
   
   
}



