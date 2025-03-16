//
//  ZLForkEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/20.
//

import ZLUIUtilities
import ZLBaseExtension
import HandyJSON
import ZLUtilities
import ZMMVVM

/**
  payload: ZLGiteeRepoModel
 */
class ZLForkEventTableViewCellData: ZLEventTableViewCellData, ZLRepoEventTableViewCellDelegate {
    

    override var zm_cellReuseIdentifier: String {
        "ZLRepoEventTableViewCell"
    }
    
    lazy var repoPayload: ZLGiteeRepoModel? = {
        ZLGiteeRepoModel.deserialize(from: model.payload)
    }()

    override func eventDescription() -> NSAttributedString {
        return "Fork 了仓库".asMutableAttributedString()
            .foregroundColor(.label(withName: "ZLLabelColor3"))
            .font(.zlMediumFont(withSize: 15))
    }
    
    // MARK: - Action
    override func navigationToRepoVC() {
        guard let full_name = repoPayload?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: full_name)
        repoVc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func navigationToSourceRepoVC() {
        guard let full_name = repoPayload?.parent?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName:full_name)
        repoVc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func repoName() -> String {
        if let human_name = repoPayload?.human_name {
            return human_name
        } else {
            return "(仓库已删除)"
        }
    }
    
    func sourceRepoName() -> String {
        repoPayload?.parent?.human_name ?? ""
    }

    func onSourceRepoButtonClicked() {
        navigationToSourceRepoVC()
    }
}



