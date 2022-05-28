//
//  ZLUserInfoHeaderCellData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/28.
//

import UIKit

class ZLUserInfoHeaderCellData: ZLTableViewBaseCellData {
    
    let model: ZLGiteeUserModel
    
    init(model: ZLGiteeUserModel) {
        self.model = model
        super.init()
    }
    
    override var cellReuseIdentifier: String {
        "ZLUserInfoHeaderCell"
    }
    
}

extension ZLUserInfoHeaderCellData: ZLUserInfoHeaderCellDataSourceAndDelegate {
    
    var name: String {
        "\(model.name ?? "")(\(model.login ?? ""))"
    }
    var time: String {
        model.created_at ?? ""
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
