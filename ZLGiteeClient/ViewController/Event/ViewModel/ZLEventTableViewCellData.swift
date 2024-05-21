//
//  ZLEventTableViewCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/5/15.
//

import Foundation
import ZLUIUtilities
import ZLBaseExtension

class ZLEventTableViewCellData: ZLTableViewBaseCellData{
    
    let model: ZLGiteeEventModel
    
    init(model: ZLGiteeEventModel) {
        self.model = model
        super.init()
        cellReuseIdentifier = "ZLEventTableViewCell"
    }
    
    override func onCellSingleTap() {
        navigationToRepoVC() 
    }
    
    func actorAvatar() ->  String {
        model.actor?.avatar_url ?? ""
    }
    
    func actorLoginName() ->  String {
        model.actor?.login ?? ""
    }
    
    func actorName() ->  String {
        model.actor?.name ?? ""
    }
    
    func eventTimerStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: model.created_at ?? Date())
    }
    
    func eventDescription() -> NSAttributedString {
        return (model.type ?? "").asMutableAttributedString()
    }
    
    func onAvatarClicked() {
        navigationToUserInfoVC() 
    }
    
    func onReportClicked() {
        
    }
    
    
    /// navigation
    func navigationToRepoVC() {
        guard let fullName = self.model.repo?.full_name else { return }
        let repoVc = ZLRepoInfoController(repoFullName: fullName)
        repoVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoVc, animated: true)
    }
    
    func navigationToUserInfoVC() {
        guard let login = model.actor?.login else { return }
        let vc = ZLUserInfoController(login: login)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Generate Cell Data 
extension ZLEventTableViewCellData {
    static func generateEventCellData(model: ZLGiteeEventModel) -> ZLEventTableViewCellData {
        switch model.type {
        case .CreateEvent:
            return ZLCreateEventTableViewCellData(model: model)
        case .ForkEvent:
            return ZLForkEventTableViewCellData(model: model)
        case .StarEvent:
            return ZLStarEventTableViewCellData(model: model)
        case .PushEvent:
            return ZLPushEventTableViewCellData(model: model)
        case .FollowEvent:
            return ZLFollowEventTableViewData(model: model)
        default:
            return ZLEventTableViewCellData(model: model)
        }
    }
}

// MARK:
typealias ZLEventType = String
extension ZLEventType {
    static let CreateEvent: ZLEventType = "CreateEvent"
    static let StarEvent: ZLEventType = "StarEvent"
    static let ForkEvent: ZLEventType = "ForkEvent"
    static let PushEvent: ZLEventType = "PushEvent"
    static let FollowEvent: ZLEventType = "FollowEvent"
}
