//
//  ZLIssueTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUtilities
import ZMMVVM
import ZLUIUtilities

class ZLIssueTableViewCellData: ZMBaseTableViewCellViewModel {

    let issueModel: ZLGiteeIssueModel

    init(issueModel: ZLGiteeIssueModel) {
        self.issueModel = issueModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLIssueTableViewCell"
    }
  
    override func zm_onCellSingleTap() {
        let vc = ZLWebContentController()
        vc.requestURL = URL(string: issueModel.html_url ?? "")
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZLIssueTableViewCellData: ZLIssueTableViewCellDelegate {

    func getIssueRepoFullName() -> String? {
        issueModel.repository?.full_name
    }

    func getIssueTitleStr() -> String? {
        issueModel.title
    }

    func isIssueClosed() -> Bool {
        return self.issueModel.state == "closed"
    }

    func getIssueAssistStr() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return "#\(issueModel.number ?? "") \(issueModel.user?.login ?? "") 创建于 \(dateFormatter.string(from: issueModel.created_at ?? Date()))"
    }

    func getIssueLabels() -> [(String, String)] {

        var labelArray: [(String, String)] = []

        for label in self.issueModel.labels {
            labelArray.append((label.name ?? "", label.color ?? ""))
        }

        return labelArray
    }

    func onClickIssueRepoFullName() {
        let vc = ZLRepoInfoController(repoFullName: issueModel.repository?.full_name ?? "")
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hasLongPressAction() -> Bool {
        if let _ = URL(string: issueModel.html_url ?? "") {
            return true
        } else {
            return false
        }
    }

    func longPressAction(view: UIView) {
        guard let sourceViewController = zm_viewController,
              let url = URL(string: issueModel.html_url ?? "") else { return }
        
        view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: sourceViewController)
    }
}
