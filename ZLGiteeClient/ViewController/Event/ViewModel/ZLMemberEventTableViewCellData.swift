//
//  ZLMemberEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/29.
//
import ZLUIUtilities
import ZLBaseExtension
import HandyJSON
import ZLUtilities

/**
  payload: ZLGiteeRepoModel
 */
class ZLMemberEventTableViewCellData: ZLEventTableViewCellData, ZLRepoEventTableViewCellDelegate {
 
    override var zm_cellReuseIdentifier: String {
        "ZLRepoEventTableViewCell"
    }
    
    lazy var memberEventPayload: ZLGiteeMemberEventPayloadModel? = {
        ZLGiteeMemberEventPayloadModel.deserialize(from: model.payload)
    }()

    override func eventDescription() -> NSAttributedString {
        guard let memberEventPayload, let action = memberEventPayload.action else { return super.eventDescription() }
        
        switch action {
        case "added":
            return "加入了仓库".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
        case "deleted":
            return "离开了仓库".asMutableAttributedString()
                .foregroundColor(.label(withName: "ZLLabelColor3"))
                .font(.zlMediumFont(withSize: 15))
        default:
            return super.eventDescription() 
        }
      
    }
    
    // MARK: - Action
    override func navigationToRepoVC() {
        guard let full_name = memberEventPayload?.repository?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: full_name)
        repoVc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func navigationToSourceRepoVC() {
        guard let full_name = memberEventPayload?.repository?.parent?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName:full_name)
        repoVc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func repoName() -> String {
        if let human_name = memberEventPayload?.repository?.human_name {
            return human_name
        } else {
            return "(仓库已删除)"
        }
    }
    
    func sourceRepoName() -> String {
        memberEventPayload?.repository?.parent?.human_name ?? ""
    }

    func onSourceRepoButtonClicked() {
        navigationToSourceRepoVC()
    }
}




