//
//  ZLGiteeRequest.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import Foundation
import Moya

enum ZLGiteeRequest {
    case user(login: String)
    case userPublicRepos(login: String)
}

extension ZLGiteeRequest: TargetType {
    
    static let version = "v5"
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://gitee.com")!
    }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .user(let login):
            return "/api/\(ZLGiteeRequest.version)/users/\(login)"
        case .userPublicRepos(let login):
            return "/api/\(ZLGiteeRequest.version)/users/\(login)/repos"
        }
    }

    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .user,.userPublicRepos:
            return .get
        }
    }

    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data {
        Data()
    }

    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case .user:
            return .requestPlain
        case .userPublicRepos:
            return .requestParameters(parameters: ["type":"all",
                                                   "sort":"full_name",
                                                   "page":1,
                                                   "per_page":20],
                                      encoding: URLEncoding())
        }
       
    }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        return .none
    }

    /// The headers to be used in the request.
    var headers: [String: String]? {
        return ["Content-Type": "application/json;charset=UTF-8"]
    }
}
