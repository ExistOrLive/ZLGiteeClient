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

/**
  payload: ZLGiteeRepoModel
 */
class ZLForkEventTableViewCellData: ZLEventTableViewCellData, ZLRepoEventTableViewCellDelegate {
    
    override init(model: ZLGiteeEventModel) {
        super.init(model: model)
        cellReuseIdentifier = "ZLRepoEventTableViewCell"
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
    override func onCellSingleTap() {
        goRepoVC()
    }
    
    func goRepoVC() {
        guard let full_name = repoPayload?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: full_name)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func goSourceRepoVC() {
        guard let full_name = repoPayload?.parent?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName:full_name)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func repoName() -> String {
        repoPayload?.human_name ?? ""
    }
    
    func sourceRepoName() -> String {
        repoPayload?.parent?.human_name ?? ""
    }

    func onSourceRepoButtonClicked() {
        goSourceRepoVC()
    }
}



