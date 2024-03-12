//
//  ZLGiteeOAuthManager.swift
//  ZLGiteeOAuth
//
//  Created by zhumeng on 01/02/2022.
//  Copyright (c) 2022 zhumeng. All rights reserved.
//

import Alamofire
import UIKit
import WebKit

// https://gitee.com/api/v5/oauth_doc#/

/// 授权方式
public enum ZLGiteeOAuthType: Int {
    case code             // 授权码方式
    case password         // 密码模式
}

/// 授权状态
public enum ZLGiteeOAuthStatus: Int {
    case initialized
    case authorize
    case getToken
    case success
    case fail
}

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

public enum ZLGiteeOAuthError: Error {
    case authorizeError(desc: String)
    
    public var localizedDescription: String {
        switch self {
        case .authorizeError(let desc):
            return desc
        }
    }
}

public protocol ZLGiteeOAuthManagerDelegate: NSObjectProtocol {
    
    func onOAuthStatusChanged(status: ZLGiteeOAuthStatus, serialNumber: String)
    
    func onOAuthSuccess(access_token: String,refresh_token: String, serialNumber: String)
    
    func onOAuthFail(status: ZLGiteeOAuthStatus, error: String, serialNumber: String)
}


public class ZLGiteeOAuthManager: NSObject {
    
    // most import config
    private let client_id: String
    private let client_secret: String
    private let redirect_uri: String
    
    private var scopes: [ZLGiteeScope] = []
    
    // status
    private var oauthStatus: ZLGiteeOAuthStatus = .initialized
    
    // delegate
    private weak var delegate: ZLGiteeOAuthManagerDelegate?
    
    // VC
    private var vc: ZLGiteeOAuthController?
    
    // serialNumer 跟踪一次OAuth流程
    fileprivate var serialNumber: String?
    
    // Alamofire Session
    private lazy var session: Session = {
        var session = Session(startRequestsImmediately:false)
        return session
    }()
    
    public init(client_id: String,
                client_secret: String,
                redirect_uri: String) {
        
        self.client_id = client_id
        self.client_secret = client_secret
        self.redirect_uri = redirect_uri
        
        super.init()
    }
    
    
    /// 开始授权
    public func startOAuth(type: ZLGiteeOAuthType,
                           delegate: ZLGiteeOAuthManagerDelegate,
                           vcBlock: (UIViewController) -> Void,
                           scopes: [ZLGiteeScope] = [],
                           force: Bool = false ) {
        
        if !force &&
            oauthStatus != .initialized {
            delegate.onOAuthFail(status: .initialized, error: "another oauth progress is running", serialNumber: "")
            return
        }
        
        reset()
        vc?.close()
        self.delegate = delegate
        self.scopes = scopes
        self.serialNumber = ZLGiteeOAuthManager.generateOAuthSerialNumber()
        
        self.onStatusChange(status: .initialized)
    
        switch type {
        case .code:
            startCodeOAuth(delegate: delegate,
                           vcBlock: vcBlock,
                           scopes: scopes)
        case .password:
            startPasswordOAuth(delegate: delegate,
                             vcBlock: vcBlock,
                             scopes: scopes)
        }
        
    }
    
    
    public static func clearCookies() {
        
        // 删除 WKWebView Cookies
        let set = Set([WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: set, modifiedSince:date) {
            
        }
        
        // 删除 HTTPCookieStorage Cookies
        if let url = URL(string: giteeMainURL),
           let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            cookies.forEach { cookie in
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    /// 授权码授权
    private func startCodeOAuth(delegate: ZLGiteeOAuthManagerDelegate,
                               vcBlock: (UIViewController) -> Void,
                               scopes: [ZLGiteeScope] = [],
                               force: Bool = false ) {
        
        let vc = ZLGiteeOAuthController(delegate: self, serialNumber: serialNumber ?? "")
        vc.modalPresentationStyle = .fullScreen
        self.vc = vc
        
        self.onStatusChange(status: .authorize)
        vcBlock(vc)
    }
    
    
    /// 设备授权
    private func startPasswordOAuth(delegate: ZLGiteeOAuthManagerDelegate,
                                  vcBlock: (UIViewController) -> Void,
                                  scopes: [ZLGiteeScope] = []) {
        
        // to-do 
    }

}

extension ZLGiteeOAuthManager {
   
    /// 生成流水号
    private static func generateOAuthSerialNumber() -> String {
        // 时间戳 + 3位随机数
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let dateStr = dateFormatter.string(from: Date())
        return "\(dateStr)\(arc4random()%10)\(arc4random()%10)\(arc4random()%10)"
    }
    
    /// 修改状态
    private func onStatusChange(status: ZLGiteeOAuthStatus) {
        self.oauthStatus = status
        self.delegate?.onOAuthStatusChanged(status: status, serialNumber: serialNumber ?? "")
    }
    
    /// 重置状态
    func reset() {
        oauthStatus = .initialized
        delegate = nil
        vc = nil
        scopes = []
    }
    
    ///
    private func onOAuthSuccess(access_token: String,refresh_token: String ) {
        self.delegate?.onOAuthSuccess(access_token: access_token, refresh_token: refresh_token, serialNumber: serialNumber ?? "")
        self.onStatusChange(status: .success)
        self.reset()
    }
    
    private func onOAuthFail(status: ZLGiteeOAuthStatus, error: String) {
        self.delegate?.onOAuthFail(status: status, error: error, serialNumber: serialNumber ?? "")
        self.onStatusChange(status: .fail)
        self.reset()
    }
    
    private func getAccessToken(code: String) {
        
        vc = nil
        onStatusChange(status: .getToken)
     
        let params = ["client_id":client_id,
                      "client_secret":client_secret,
                      "code":code,
                      "redirect_uri":redirect_uri,
                      "grant_type":"authorization_code"]
        
        let httpHeaders = HTTPHeaders(["Accept":"application/json"])
        let request = session.request(ZLGiteeOAuthManager.accessTokenURL,
                                      method: .post,
                                      parameters: params,
                                      encoder: .json,
                                      headers:httpHeaders)
        
        request.responseDecodable(of: ZLGiteeOAuthResult.self) { [weak self] response in
            guard let self = self else { return }
            
            switch(response.result) {
            case .success(let result):
                if let access_token = result.access_token,
                   let refresh_token  = result.refresh_token {
                    self.onOAuthSuccess(access_token: access_token,
                                        refresh_token: refresh_token)
                } else {
                    self.onOAuthFail(status: .getToken, error: result.error_description ?? "")
                }
            case .failure(let error):
                self.onOAuthFail(status: .getToken, error: error.localizedDescription)
            }
            
            self.reset()
        }
        
        request.resume()
    }
}

extension ZLGiteeOAuthManager: ZLGiteeOAuthControllerDelegate {

    func getOAuthType(serialNumber: String) -> ZLGiteeOAuthType? {
        guard serialNumber == self.serialNumber,
              oauthStatus == .authorize else { return nil}
        return .code
    }
    
    func getAuthorizeCodeURL(serialNumber: String) -> URL? {
        guard serialNumber == self.serialNumber,
              oauthStatus == .authorize else { return nil}
        
        var urlComponents = URLComponents(string: ZLGiteeOAuthManager.authrizeCodeURL)
        let params = ["client_id":client_id,
                      "redirect_uri":redirect_uri,
                      "response_type": "code",
                      "state": serialNumber]
        let tmpEncoder = URLEncodedFormEncoder()
        do {
            let queryStr: String = try tmpEncoder.encode(params)
            urlComponents?.percentEncodedQuery = queryStr
            if let url = urlComponents?.url {
                return url
            } else {
                self.onOAuthFail(status: oauthStatus, error: "parameters encode fail")
                return nil
            }
        } catch {
            self.onOAuthFail(status: oauthStatus, error: error.localizedDescription)
            return nil
        }
    }
    
    func getAuthorizeCodeRedirectURL(serialNumber: String) -> String? {
        guard serialNumber == self.serialNumber,
              oauthStatus == .authorize else { return nil}
        return redirect_uri
    }
    
    func onAuthorizeCodeSuccess(code: String, serialNumber: String) {
        guard serialNumber == self.serialNumber,
              oauthStatus == .authorize else { return }
        self.getAccessToken(code: code)
    }
    
    func onAuthorizeCodeFail(error: Error,serialNumber: String) {
        guard serialNumber == self.serialNumber,
              oauthStatus == .authorize else { return }
        self.onOAuthFail(status: oauthStatus, error: error.localizedDescription)
    }
    
    func onOAuthClose(serialNumber: String){
        guard serialNumber == self.serialNumber,
              oauthStatus == .authorize else { return }
        self.onOAuthFail(status: oauthStatus, error: "cancel")
    }
}


extension ZLGiteeOAuthManager {
    /// 授权码授权URL
    static let authrizeCodeURL = "https://gitee.com/oauth/authorize"
    
    /// accessTokenURL
    static let accessTokenURL = "https://gitee.com/oauth/token"
    

    static let giteeMainURL = "https://gitee.com"
}
