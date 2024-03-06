//
//  ZLUserInfoHeaderCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/28.
//

import UIKit
import HandyJSON
import ZLUIUtilities

class ZLUserInfoHeaderCellData: ZLTableViewBaseCellData {
    
    let model: ZLGiteeUserModel
    
    init(model: ZLGiteeUserModel) {
        self.model = model
        super.init()
        self.cellReuseIdentifier = "ZLUserInfoHeaderCell"
    }
}

extension ZLUserInfoHeaderCellData: ZLUserInfoHeaderCellDataSourceAndDelegate {
    
    var name: String {
        "\(model.name ?? "")(\(model.login ?? ""))"
    }
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let time = dateFormatter.string(from: model.created_at ?? Date())
        let createdAtStr = "创建于"
        return "\(createdAtStr) \((time))"
    }
    var desc: String {
        model.bio ?? ""
    }
    var avatarUrl: String {
        model.avatar_url ?? ""
    }

    var reposNum: String {
        String(model.public_repos)
    }
    var starReposNum: String {
        String(model.stared)
    }
    var followersNum: String {
        String(model.followers)
    }
    var followingNum: String {
        String(model.following)
    }

    var showBlockButton: Bool {
        false
    }
    var showFollowButton: Bool {
        false
    }

    var blockStatus: Bool {
        false
    }
    var followStatus: Bool {
        false
    }

    func onFollowButtonClicked() {
        
    }
    func onBlockButtonClicked() {
        
    }

    func onReposNumButtonClicked() {
        let vc = ZLUserReposListController()
        vc.login = model.login ?? ""
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStarReposNumButtonClicked() {
        let vc = ZLUserStarsListController()
        vc.login = model.login ?? ""
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onFollowsNumButtonClicked() {
        let vc = ZLUserFollowerListController()
        vc.login = model.login ?? "" 
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onFollowingNumButtonClicked() {
        let vc = ZLUserFollowingListController()
        vc.login = model.login ?? ""
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
