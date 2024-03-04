//
//  ZLCommitTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/4.
//

import Foundation
import ZLBaseUI
import ZLUIUtilities

class ZLCommitTableViewCellData: ZLTableViewBaseCellData {

    let commitModel: ZLGiteeCommitModel

     init(commitModel: ZLGiteeCommitModel) {
         self.commitModel = commitModel
         super.init()
     }

    override var cellReuseIdentifier: String {
        "ZLCommitTableViewCell"
    }
 
    override func onCellSingleTap() {
        let vc = ZLWebContentController()
        vc.requestURL = URL(string: commitModel.html_url ?? "")
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZLCommitTableViewCellData: ZLCommitTableViewCellDelegate {
    func getCommiterAvaterURL() -> String? {
        return self.commitModel.committer?.avatar_url
    }

    func getCommiterLogin() -> String {
        return self.commitModel.committer?.login ?? ""
    }
    
    func getCommitTitle() -> String {
        return self.commitModel.commit?.message ?? ""
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


