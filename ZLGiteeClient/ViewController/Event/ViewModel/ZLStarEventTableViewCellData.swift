//
//  ZLStarEventTableViewdata.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/21.
//

import ZLUIUtilities
import ZLBaseExtension
import HandyJSON
import ZLUtilities

/**
  payload: ZLGiteeRepoModel
 */
class ZLStarEventTableViewCellData: ZLEventTableViewCellData, ZLRepoEventTableViewCellDelegate {
    
    override init(model: ZLGiteeEventModel) {
        super.init(model: model)
        cellReuseIdentifier = "ZLRepoEventTableViewCell"
    }
    
    override func eventDescription() -> NSAttributedString {
        return "Star 了仓库".asMutableAttributedString()
            .foregroundColor(.label(withName: "ZLLabelColor3"))
            .font(.zlMediumFont(withSize: 15))
    }
    
    // MARK: - Action
    override func onCellSingleTap() {
        goRepoVC()
    }
    
    func goRepoVC() {
        guard let full_name = model.repo?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: full_name)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
   
    
    func repoName() -> String {
        return model.repo?.human_name ?? ""
    }
    
    func sourceRepoName() -> String {
        ""
    }
    
    func onSourceRepoButtonClicked() {
     
    }

}


