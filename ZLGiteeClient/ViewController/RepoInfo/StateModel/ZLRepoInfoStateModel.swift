//
//  ZLRepoInfoPresenter.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/6/4.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation

protocol ZLRepoInfoStateModelDelegate: AnyObject {
    func onWatchStatusUpdate()
    func onStarStatusUpdate()
    func onNeedReloadData()
}

class ZLRepoInfoStateModel: NSObject {
    // Repo Full Name
    let repoFullName: String
    /// login Name
    let loginName: String
    /// repoName
    let repoName: String
    // repoInfo
    var repoInfo: ZLGiteeRepoModel?
    /// 是否watch
    var viewerIsWatch: Bool = false
    /// 是否star
    var viewerIsStar: Bool = false
    /// 当前分支
    var currentBranch: String?
    
    weak var delegate: ZLRepoInfoStateModelDelegate?
    
    init(repoFullName: String) {
        self.repoFullName = repoFullName
        let nameArray = repoFullName.split(separator: "/")
        self.loginName = String(nameArray.first ?? "")
        self.repoName = String(nameArray.last ?? "")
        super.init()
    }
}

// MARK: - Request
extension ZLRepoInfoStateModel {
    
    /// 请求repo
    func loadRepoRequest(callBack: @escaping (Bool,String) -> Void){
        
        ZLGiteeRequest.sharedProvider.requestRest(.repoInfo(login: loginName, repoName: repoName), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            if result, let model = model as? ZLGiteeRepoModel {
                self.repoInfo = model
                if self.currentBranch == nil {
                    self.currentBranch = model.default_branch
                }
                callBack(true,"")
            } else {
                callBack(false,msg)
            }
        })
    }
    
    
    func changeBranch(newBranch: String) {
        currentBranch = newBranch
    }
    
    
    func getRepoWatchStatus() {
        ZLGiteeRequest.sharedProvider.requestRest(.isWatchRepo(login: loginName, repoName: repoName), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            self.viewerIsWatch = result
            self.delegate?.onNeedReloadData()
        })
    }
    
    func getRepoStarStatus() {
        ZLGiteeRequest.sharedProvider.requestRest(.isStarRepo(login: loginName, repoName: repoName), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            self.viewerIsStar = result
            self.delegate?.onNeedReloadData()
        })
    }
    
    func watchRepo(callBack: @escaping (Bool,String) -> Void)  {
        
        if viewerIsWatch {
            ZLGiteeRequest.sharedProvider.requestRest(.unwatchRepo(login: loginName, repoName: repoName), completion: { [weak self] (result, model, msg) in
                guard let self else { return }
                if result {
                    self.viewerIsWatch = false
                }
                callBack(result,msg)
                self.delegate?.onWatchStatusUpdate()
            })
        } else {
            ZLGiteeRequest.sharedProvider.requestRest(.watchRepo(login: loginName, repoName: repoName,watchType: "watching"), completion: { [weak self] (result, model, msg) in
                guard let self else { return }
                if result {
                    self.viewerIsWatch = true
                }
                callBack(result,msg)
                self.delegate?.onWatchStatusUpdate()
            })
        }
    }
    
    func starRepo(callBack: @escaping (Bool,String) -> Void)  {
        
        if viewerIsStar {
            ZLGiteeRequest.sharedProvider.requestRest(.unstarRepo(login: loginName, repoName: repoName), completion: { [weak self] (result, model, msg) in
                guard let self else { return }
                if result {
                    self.viewerIsStar = false
                }
                callBack(result,msg)
                self.delegate?.onStarStatusUpdate()
            })
        } else {
            ZLGiteeRequest.sharedProvider.requestRest(.starRepo(login: loginName, repoName: repoName), completion: { [weak self] (result, model, msg) in
                guard let self else { return }
                if result {
                    self.viewerIsStar = true
                }
                callBack(result,msg)
                self.delegate?.onStarStatusUpdate()
            })
        }
    }
    
    func forkRepo(callBack: @escaping (Bool,ZLGiteeRepoModel?,String) -> Void)  {
        ZLGiteeRequest.sharedProvider.requestRest(.forkRepo(login: loginName, repoName: repoName), completion: { [weak self] (result, model, msg) in
            guard let self else { return }
            callBack(result, model as? ZLGiteeRepoModel, msg)
        })
    }
}
