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
    case userFollower(login: String, page: Int, per_page: Int)
    case userFollowing(login: String, page: Int, per_page: Int)
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
        case .userFollower(let login, _, _):
            return "/api/\(ZLGiteeRequest.version)/users/\(login)/followers"
        case.userFollowing(let login, _, _):
            return "/api/\(ZLGiteeRequest.version)/users/\(login)/following"
        }
    }

    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .user,.userPublicRepos, .userFollower, .userFollowing:
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
        case .userFollower(_, let page, let per_page):
            return .requestParameters(parameters: ["page":page,
                                                   "per_page":per_page,
                                                   "access_token":"618ac9c82d588bbe793a6c0924c86ade"],
                                      encoding: URLEncoding())
        case .userFollowing(_, let page, let per_page):
            return .requestParameters(parameters: ["page":page,
                                                   "per_page":per_page,
                                                   "access_token":"618ac9c82d588bbe793a6c0924c86ade"],
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
