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
class ZLGiteeOAuthUserServiceModel: NSObject {
    
    private(set) var currentLogin: String = ""
    
    private(set) var access_token: String = ""
    
    private(set) var refresh_token: String = ""
    
    private(set) var currentUserModel: ZLGiteeUserBriefModel?
    
    private(set) var isRefreshToken: Bool = false
    
    private(set) var lastRefreshTokenSuccessTimeStamp: TimeInterval = 0
    
    static let sharedService: ZLGiteeOAuthUserServiceModel = {
        ZLGiteeOAuthUserServiceModel()
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private override init() {
        super.init()
        registerNotifications()
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
extension ZLGiteeOAuthUserServiceModel {
    
    class ZLGiteeOAuthResult: Decodable {
        var access_token: String?
        var token_type: String?
        var scope: String?
        var created_at: TimeInterval?
        var refresh_token: String?
        var expires_in: TimeInterval?
        
        var error: String?
        var error_description: String?
    }
    
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
                      let userModel = ZLGiteeUserBriefModel.deserialize(from: dic) else {
                    callBack?(false , "Parse Error")
                    return
                }
                self.storeUserAndToken(login: userModel.login ?? "",
                                       access_token: access_token,
                                       refresh_token: refresh_token,
                                       currentUserModel: userModel)
                NotificationCenter.default.post(name: OAuthSuccessNotification, object: nil)
                callBack?(true,"")
            case .failure(let error):
                callBack?(false , error.localizedDescription)
            }
        }
        request.resume()
    }
    
    
    func refreshAccessToken(callBack: @escaping (Bool, String, String ) -> Void ) {
        
        let params = ["refresh_token": refresh_token,
                      "grant_type":"refresh_token"]
        
        let httpHeaders = HTTPHeaders(["Accept":"application/json"])
        let request = session.request("https://gitee.com/oauth/token",
                                      method: .post,
                                      parameters: params,
                                      encoder: .json,
                                      headers:httpHeaders)
        
        request.responseDecodable(of: ZLGiteeOAuthResult.self) { [weak self] response in
            guard let _ = self else { return }
            
            switch(response.result) {
            case .success(let result):
                if let access_token = result.access_token,
                   let refresh_token  = result.refresh_token {
                    callBack(true, access_token, refresh_token)
                } else {
                    callBack(false, "", "")
                }
            case .failure(let _):
                callBack(false, "", "")
            }
        }
        
        request.resume()
    }

    var isLogined: Bool {
        !currentLogin.isEmpty && !access_token.isEmpty
    }
    
    func logout() {
        removeUserAndToken(login: currentLogin)
        NotificationCenter.default.post(name: AccessAndRefreshTokenInvalidNotification, object: nil)
    }
}


// MARK: Persistence
extension ZLGiteeOAuthUserServiceModel {
    
    static let giteeKeyChainService = "com.zm.ZLGiteeClient"
    
    class ZLGiteeUserTokenModel : HandyJSON {
        required init() {}
        var login: String = ""
        var access_token: String = ""
        var refresh_token: String = ""
    }
    
    /// 读取当前登录用户的信息
    func readCurrentUser() {
        
        /// 获取当前用户 login
        guard let currentLogin = UserDefaults.standard.string(forKey: "ZLGiteeCurrentUser"),
              !currentLogin.isEmpty else {
            reset()
            return
        }
        
        /// 获取当前用户model
        let userModelArray = readOAuthUserModelArray()
        guard let model = userModelArray.first(where: { $0.login == currentLogin }) else {
            reset()
            return
        }
        
        /// 获取用户token
        let userTokenArray = readOAuthUserTokenArray()
        guard let userTokenModel = userTokenArray.first(where: { $0.login == currentLogin }) else {
            reset()
            return
        }
      
        self.currentLogin = currentLogin
        self.access_token = userTokenModel.access_token
        self.refresh_token = userTokenModel.refresh_token
        self.currentUserModel = model
    }
    
    /// 清除token
    func removeUserAndToken(login: String) {
    
        var userModelArray = readOAuthUserModelArray()
        userModelArray.removeAll { $0.login == login }
      
        var userTokenArray = readOAuthUserTokenArray()
        userTokenArray.removeAll { $0.login == login }
        
        setOAuthUserModelArray(array: userModelArray)
        setOAuthUserTokenArray(array: userTokenArray)
        
        UserDefaults.standard.setValue(login, forKey: "ZLGiteeCurrentUser")
        UserDefaults.standard.synchronize()
        
        /// 重置token
        if let currentLogin = UserDefaults.standard.string(forKey: "ZLGiteeCurrentUser"),
           currentLogin == login {
            UserDefaults.standard.removeObject(forKey: "ZLGiteeCurrentUser")
            reset()
        }
    }
    
    /// 重置当前user token
    func resetCurrentUserToken(access_token: String,
                               refresh_token: String) {
        let tokenModel = ZLGiteeUserTokenModel()
        tokenModel.login = currentLogin
        tokenModel.access_token = access_token
        tokenModel.refresh_token = refresh_token
        
        var userTokenArray = readOAuthUserTokenArray()
        userTokenArray.removeAll { $0.login == currentLogin }
        userTokenArray.append(tokenModel)
       
        self.access_token = access_token
        self.refresh_token = refresh_token
    }
    
    /// 保存新token
    func storeUserAndToken(login: String,
                           access_token: String,
                           refresh_token: String,
                           currentUserModel: ZLGiteeUserBriefModel) {
        let tokenModel = ZLGiteeUserTokenModel()
        tokenModel.login = login
        tokenModel.access_token = access_token
        tokenModel.refresh_token = refresh_token
        
        var userModelArray = readOAuthUserModelArray()
        userModelArray.removeAll { $0.login == login }
        userModelArray.append(currentUserModel)
        
        var userTokenArray = readOAuthUserTokenArray()
        userTokenArray.removeAll { $0.login == login }
        userTokenArray.append(tokenModel)
        
        setOAuthUserModelArray(array: userModelArray)
        setOAuthUserTokenArray(array: userTokenArray)
        UserDefaults.standard.setValue(login, forKey: "ZLGiteeCurrentUser")
        UserDefaults.standard.synchronize()
    
        self.access_token = access_token
        self.refresh_token = refresh_token
        self.currentLogin = login
        self.currentUserModel = currentUserModel
    }
    
    
    /// 读取所有登录的用户Model
    func readOAuthUserModelArray() -> [ZLGiteeUserBriefModel] {
        guard let userModelArrayData = UserDefaults.standard.data(forKey: "ZLGiteeUserArray"),
              let json = try? JSONSerialization.jsonObject(with: userModelArrayData) as? [Any],
              let userModelArray = [ZLGiteeUserBriefModel].deserialize(from: json)?.compactMap({ $0 }) else {
            return []
        }
        return userModelArray
    }
    
    /// 保存所有登录的用户Model
    func setOAuthUserModelArray(array: [ZLGiteeUserBriefModel]) {
        if array.isEmpty {
            UserDefaults.standard.removeObject(forKey: "ZLGiteeUserArray")
        } else {
            if let newData = try? JSONSerialization.data(withJSONObject: array.toJSON())  {
                UserDefaults.standard.set(newData, forKey: "ZLGiteeUserArray")
            } else {
                UserDefaults.standard.removeObject(forKey: "ZLGiteeUserArray")
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    /// 读取所有登录的用户Model
    func readOAuthUserTokenArray() -> [ZLGiteeUserTokenModel] {
        let keyChain = Keychain(service: ZLGiteeOAuthUserServiceModel.giteeKeyChainService)
        
        guard let userTokenArrayData = keyChain[data: "ZLGiteeUserTokenArray"],
              let json = try? JSONSerialization.jsonObject(with: userTokenArrayData) as? [Any],
              let userTokenArray = [ZLGiteeUserTokenModel].deserialize(from: json)?.compactMap({ $0 }) else {
            return []
        }
        return userTokenArray
    }
    
    /// 保存所有登录的用户Model
    func setOAuthUserTokenArray(array: [ZLGiteeUserTokenModel]) {
        let keyChain = Keychain(service: ZLGiteeOAuthUserServiceModel.giteeKeyChainService)
        if array.isEmpty {
            keyChain[data: "ZLGiteeUserTokenArray"] = nil
        } else {
            if let newData = try? JSONSerialization.data(withJSONObject: array.toJSON())  {
                keyChain[data: "ZLGiteeUserTokenArray"] = newData
            } else {
                keyChain[data: "ZLGiteeUserTokenArray"] = nil
            }
        }
        UserDefaults.standard.synchronize()
    }
}

// MARK: - Notification
/// AccessToken 失效通知
let AccessTokenInvalidNotification = Notification.Name(rawValue: "AccessTokenInvalidNotification")

/// AccessToken RefreshToken 失效通知 都失效
let AccessAndRefreshTokenInvalidNotification = Notification.Name(rawValue: "AccessAndRefreshTokenInvalidNotification")

/// 刷新 Token 成功 通知
let RefreshTokenNotification = Notification.Name(rawValue: "RefreshTokenNotification")

/// OAuth 或者 设置 Token 成功 通知
let OAuthSuccessNotification = Notification.Name(rawValue: "OAuthSuccessNotification")

extension ZLGiteeOAuthUserServiceModel {
   
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAccessTokenInvalid), name: AccessTokenInvalidNotification, object: nil)
    }
    
    @objc func onAccessTokenInvalid() {
        guard isRefreshToken == false else { return }
        
        guard Date().timeIntervalSince1970 - lastRefreshTokenSuccessTimeStamp > 10 else  { return }
        /// access_token 失效刷新
        isRefreshToken = true
        if refresh_token.isEmpty {
            removeUserAndToken(login: currentLogin)
            NotificationCenter.default.post(name: AccessAndRefreshTokenInvalidNotification, object: nil)
            isRefreshToken = false
            return
        }
        
        refreshAccessToken { [weak self]res, access_token, refresh_token in
            guard let self else { return }
            if res {
                self.lastRefreshTokenSuccessTimeStamp = Date().timeIntervalSince1970
                self.resetCurrentUserToken(access_token: access_token, refresh_token: refresh_token)
                NotificationCenter.default.post(name: RefreshTokenNotification, object: nil)
            } else {
                self.removeUserAndToken(login: self.currentLogin)
                self.reset()
                NotificationCenter.default.post(name: AccessAndRefreshTokenInvalidNotification, object: nil)
            }
            self.isRefreshToken = false
        }
    }
}
