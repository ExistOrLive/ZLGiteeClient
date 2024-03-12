//
//  ZLGiteeTokenManager.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/3/12.
//

import Foundation
import Alamofire
import HandyJSON
import KeychainAccess

/// 登录用户管理器
class ZLGiteeOAuthUserManager: NSObject {
    
    private(set) var currentLogin: String = ""
    
    private(set) var access_token: String = ""
    
    private(set) var refresh_token: String = ""
    
    private(set) var currentUserModel: ZLGiteeUserModel?
    
    static let manager: ZLGiteeOAuthUserManager = {
        ZLGiteeOAuthUserManager()
    }()
    
    private override init() {
        super.init()
        readCurrentUser()
    }
    
    private lazy var session: Session = {
       let sessionConfiguration = URLSessionConfiguration.default
       sessionConfiguration.timeoutIntervalForRequest = 30
       let session = Session(configuration: sessionConfiguration,
                             startRequestsImmediately: false)
        return session
    }()
    
    func reset() {
        currentLogin = ""
        access_token = ""
        refresh_token = ""
        currentUserModel = nil
    }
}



// MARK:  outer method
extension ZLGiteeOAuthUserManager {
    
    func checkToken(access_token: String,
                    refresh_token: String = "",
                    callBack: ((Bool, String) -> Void)? = nil) {
        
        let request = session.request("https://gitee.com/api/v5/user",
                                      method: .get,
                                      parameters: ["access_token": access_token])
        
        request.responseData {  [weak self] data in
            guard let self else { return }
            switch data.result {
            case .success(let data):
                guard let dic = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
                      let userModel = ZLGiteeUserModel.deserialize(from: dic) else {
                    callBack?(false , "Parse Error")
                    return
                }
                self.storeUserAndToken(login: userModel.login ?? "",
                                       access_token: access_token,
                                       refresh_token: refresh_token,
                                       currentUserModel: userModel)
                callBack?(true,"")
            case .failure(let error):
                callBack?(false , error.localizedDescription)
            }
        }
        request.resume()
    }

    var isLogined: Bool {
        !currentLogin.isEmpty
    }
}


// MARK: Persistence
extension ZLGiteeOAuthUserManager {
    
    static let giteeKeyChainService = "com.zm.ZLGiteeClient"
    
    class ZLGiteeUserAndTokenPersistenceModel: HandyJSON {
        required init() {}
        var login: String = ""
        var access_token: String = ""
        var refresh_token: String = ""
        var currentUserModel: ZLGiteeUserModel?
    }
    
    func readCurrentUser() {
        
        let keyChain = Keychain(service: ZLGiteeOAuthUserManager.giteeKeyChainService)
        /// 清除当前token
        guard let currentLogin = keyChain["ZLGiteeCurrentUser"],
              !currentLogin.isEmpty,
              let userTokenArrayData = keyChain[data: "ZLGiteeUserArray"],
              let json = try? JSONSerialization.jsonObject(with: userTokenArrayData) as? [Any],
              let userTokenArray = [ZLGiteeUserAndTokenPersistenceModel].deserialize(from: json)?.compactMap({$0}),
        let userAndTokenModel = userTokenArray.first(where: { $0.login == currentLogin }) else {
            reset()
            return
        }
        self.currentLogin = currentLogin
        self.access_token = userAndTokenModel.access_token
        self.refresh_token = userAndTokenModel.refresh_token
        self.currentUserModel = userAndTokenModel.currentUserModel
    }
    
    
    /// 保存新token
    func removeUserAndToken(login: String) {
    
        let keyChain = Keychain(service: ZLGiteeOAuthUserManager.giteeKeyChainService)
        
        /// 清除token
        if let userTokenArrayData = keyChain[data: "ZLGiteeUserArray"],
           let json = try? JSONSerialization.jsonObject(with: userTokenArrayData) as? [Any],
           var userTokenArray = [ZLGiteeUserAndTokenPersistenceModel].deserialize(from: json)?.compactMap({$0}) {
            
            userTokenArray.removeAll { $0.login == login}
            if let newData = try? JSONSerialization.data(withJSONObject: userTokenArray.toJSON())  {
                keyChain[data: "ZLGiteeUserArray"] = newData
            }
        }
        
        /// 清除当前token
        if let currentLogin = keyChain["ZLGiteeCurrentUser"],
           currentLogin == login {
            keyChain["ZLGiteeCurrentUser"] = ""
        }
    }
    
    
    /// 保存新token
    func storeUserAndToken(login: String,
                           access_token: String,
                           refresh_token: String,
                           currentUserModel: ZLGiteeUserModel) {
        let model = ZLGiteeUserAndTokenPersistenceModel()
        model.login = login
        model.access_token = access_token
        model.refresh_token = refresh_token
        model.currentUserModel = currentUserModel
        
        
        let keyChain = Keychain(service: ZLGiteeOAuthUserManager.giteeKeyChainService)
        
        /// 保存token
        if let userTokenArrayData = keyChain[data: "ZLGiteeUserArray"],
           let json = try? JSONSerialization.jsonObject(with: userTokenArrayData) as? [Any],
           var userTokenArray = [ZLGiteeUserAndTokenPersistenceModel].deserialize(from: json)?.compactMap({$0}) {
            
            userTokenArray.removeAll { $0.login == model.login}
            userTokenArray.append(model)
            if let newData = try? JSONSerialization.data(withJSONObject: userTokenArray.toJSON())  {
                keyChain[data: "ZLGiteeUserArray"] = newData
            }
        } else {
            let userTokenArray = [model]
            if let newData = try? JSONSerialization.data(withJSONObject: userTokenArray.toJSON())  {
                keyChain[data: "ZLGiteeUserArray"] = newData
            }
        }
        
        /// 保存当前login
        keyChain["ZLGiteeCurrentUser"] = model.login
        
        
        self.access_token = access_token
        self.refresh_token = refresh_token
        self.currentLogin = login
        self.currentUserModel = currentUserModel
    }
}
