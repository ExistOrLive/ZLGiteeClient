//
//  ZLIssueEventTableViewCelldata.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/23.
//

import Foundation
import ZLUtilities
import ZLUIUtilities
import ZLBaseExtension

class ZLIssueEventTableViewCellData: ZLEventTableViewCellData, ZLIssueEventTableViewCellDelegate {
    
    override init(model: ZLGiteeEventModel) {
        super.init(model: model)
        cellReuseIdentifier = "ZLIssueEventTableViewCell"
    }
    
    lazy var issuePayload: ZLGiteeIssueEventPayloadModel? = {
        ZLGiteeIssueEventPayloadModel.deserialize(from: model.payload)
    }()

    /// 真滴服了，所有IssueEvent的Action 和 state 都是最终状态
    override func eventDescription() -> NSAttributedString {
        guard let issuePayload,
              let action = issuePayload.action else { return super.eventDescription() }
        
        return  "创建了任务或修改了任务状态：\(issuePayload.issue_state ?? "")".asMutableAttributedString()
            .foregroundColor(.label(withName: "ZLLabelColor3"))
            .font(.zlMediumFont(withSize: 15))
    }
    
    // MARK: - Action
    override func navigationToRepoVC() {
        guard let full_name = issuePayload?.repository?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: full_name)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    override func onCellSingleTap() {
        guard let url = issuePayload?.html_url else { return }
        let vc = ZLWebContentController()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL(string: url)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

    func issueId() -> String {
        return issuePayload?.number ?? ""
    }
    
    func issueTitle() -> String {
        return issuePayload?.title ?? ""
    }
    
    func issueRepoHumanName() -> String {
        return issuePayload?.repository?.human_name ?? ""
    }
    
    func onIssueRepoClicked() {
        navigationToRepoVC()
    }
   
}


