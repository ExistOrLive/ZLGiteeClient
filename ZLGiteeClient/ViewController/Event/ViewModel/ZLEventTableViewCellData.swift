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
        let vc = ZLUserInfoController(login: actorLoginName())
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func onReportClicked() {
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
}
