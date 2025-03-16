//
//  ZLCommitTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/4.
//

import Foundation
import ZMMVVM

class ZLCommitTableViewCellData: ZMBaseTableViewCellViewModel {

    let commitModel: ZLGiteeCommitModel

    init(commitModel: ZLGiteeCommitModel) {
        self.commitModel = commitModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLCommitTableViewCell"
    }

    override func zm_onCellSingleTap() {
        let vc = ZLWebContentController()
        vc.requestURL = URL(string: commitModel.html_url ?? "")
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZLCommitTableViewCellData: ZLCommitTableViewCellDelegate {
    
    func getCommiterLogin() -> String {
        return self.commitModel.commit?.author?.name ?? ""
    }
    
    func getCommitTitle() -> String {
        return (self.commitModel.commit?.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func getCommitSha() -> String {
        return String(self.commitModel.sha?.prefix(7) ?? "")
    }

    func getAssistInfo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return "\(self.commitModel.committer?.name ?? "") 提交于 \(dateFormatter.string(from: self.commitModel.commit?.committer?.date ?? Date())) "
    }
}


