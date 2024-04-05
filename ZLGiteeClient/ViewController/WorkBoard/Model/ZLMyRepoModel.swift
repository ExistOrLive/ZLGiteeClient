//
//  ZLMyRepoModel.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/27.
//

import Foundation

// MARK: - ZLGiteeAffiliationType 仓库所属
enum ZLGiteeMyRepoAffiliationType: CaseIterable {
    case all
    case owner                    // 我自己的
    case collaborator             // 我参与的
//    case organization_member      // 在组织中参与的
//    case enterprise_member        // 在企业中参与的
//    case admin                    // 所有有权限的，包括所管理的组织中所有仓库、所管理的企业的所有仓库
    
    var value: String? {
        switch self {
        case .all: return nil
        case .owner: return "owner"
        case .collaborator: return "collaborator"
//        case .organization_member: return "organization_member"
//        case .enterprise_member: return "enterprise_member"
//        case .admin: return "admin"
        }
    }
    
    var title: String {
        switch self {
        case .all: return "所有"
        case .owner: return "我自己的"
        case .collaborator: return "我参与的"
//        case .organization_member: return "在组织中参与的"
//        case .enterprise_member: return "在企业中参与的"
//        case .admin: return "所有参与的"
        }
    }
}


// MARK: - ZLGiteeMyRepoVisibilityType 仓库可见性
enum ZLGiteeMyRepoVisibilityType: CaseIterable {
    case all
    case pub                    // 公开的
    case priva                  // 私有的
    
    var value: String? {
        switch self {
        case .all: return nil
        case .pub: return "public"
        case .priva: return "private"
        }
    }
    
    var title: String {
        switch self {
        case .all: return "全部"
        case .pub: return "公开的"
        case .priva: return "私有的"
        }
    }
}

// MARK: - ZLGiteeMyRepoSortType 仓库排序
enum ZLGiteeMyRepoSortType: CaseIterable {
    case full_name                // 仓库名称
    case created                  // 最新创建
    case updated                  // 最近更新
    case pushed                   // 最近推送
 
    
    var value: String {
        switch self {
        case .full_name: return "full_name"
        case .created: return "created"
        case .updated: return "updated"
        case .pushed: return "pushed"
        }
    }
    
    var title: String {
        switch self {
        case .full_name: return "仓库名称"
        case .created: return "最新创建"
        case .updated: return "最近更新"
        case .pushed: return "最近推送"
        }
    }
}
