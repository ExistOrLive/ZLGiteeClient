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
import ZMMVVM

/**
  payload: ZLGiteeRepoModel
 */
class ZLStarEventTableViewCellData: ZLEventTableViewCellData, ZLRepoEventTableViewCellDelegate {
    
    override init(model: ZLGiteeEventModel) {
        super.init(model: model)
    }
    
    override var zm_cellReuseIdentifier: String {
        "ZLRepoEventTableViewCell"
    }
    
    override func eventDescription() -> NSAttributedString {
        return "Star 了仓库".asMutableAttributedString()
            .foregroundColor(.label(withName: "ZLLabelColor3"))
            .font(.zlMediumFont(withSize: 15))
    }
      
    func repoName() -> String {
        return model.repo?.human_name ?? ""
    }
}


