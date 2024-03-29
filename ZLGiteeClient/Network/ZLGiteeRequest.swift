//
//  ZLGiteeRequest.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/20.
//

import Foundation
import Moya


func GiteeAccessToken() -> String {
    ZLGiteeOAuthUserServiceModel.sharedService.access_token
}

extension String {
    var urlPathEncoding: String {
        return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}

enum ZLGiteeRequest {
    
    // user
    case user(login: String)
    case userPublicRepos(login: String, page: Int, per_page: Int)
    case userFollower(login: String, page: Int, per_page: Int)
    case userFollowing(login: String, page: Int, per_page: Int)
    case userStars(login: String)
    
    // repo 
    case repoInfo(login: String, repoName: String)
    
    case forkRepo(login: String, repoName: String)
    case starRepo(login: String, repoName: String)
    case unstarRepo(login: String, repoName: String)
    case isStarRepo(login: String, repoName: String)
    case watchRepo(login: String, repoName: String, watchType: String)
    case unwatchRepo(login: String, repoName: String)
    case isWatchRepo(login: String, repoName: String)
    
    case repoIssuesList(login: String, repoName: String, page: Int, per_page: Int)
    case repoStarsList(login: String, repoName: String, page: Int, per_page: Int)
    case repoWatchingsList(login: String, repoName: String, page: Int, per_page: Int)
    case repoForksList(login: String, repoName: String, page: Int, per_page: Int)
    case repoCommitsList(login: String, repoName: String, page: Int, per_page: Int)
    
    case latestRepoList(page: Int, per_page: Int)
    case popularRepoList(page: Int, per_page: Int)
    case recommendRepoList(page: Int, per_page: Int)
    
    case searchRepos(q: String, page: Int, per_page: Int)
    case searchUsers(q: String, page: Int, per_page: Int)
    case searchIssues(q: String, page: Int, per_page: Int)
}

extension ZLGiteeRequest {
    static var sharedProvider: MoyaProvider<ZLGiteeRequest> = {
       return MoyaProvider<ZLGiteeRequest>()
    }()
}

extension ZLGiteeRequest: RestTargetType {
    
    var version: String {
        switch self {
        case .latestRepoList,.popularRepoList,.recommendRepoList:
            return "v3"
        default:
            return "v5"
        }
    }
    static let version = "v5"
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://gitee.com")!
    }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .user(let login):
            return "/api/\(version)/users/\(login.urlPathEncoding)"
        case .userPublicRepos(let login, _, _):
            return "/api/\(version)/users/\(login.urlPathEncoding)/repos"
        case .userFollower(let login, _, _):
            return "/api/\(version)/users/\(login.urlPathEncoding)/followers"
        case .userFollowing(let login, _, _):
            return "/api/\(version)/users/\(login.urlPathEncoding)/following"
        case .userStars(let login):
            return "/api/\(version)/users/\(login.urlPathEncoding)/starred"
        case .repoInfo(let login, let repoName):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)"
        case .repoIssuesList(let login,let repoName, _ ,_ ):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/issues"
        case .forkRepo(let login, let repoName):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/forks"
        case .starRepo(let login, let repoName),
             .unstarRepo(let login, let repoName),
             .isStarRepo(let login, let repoName):
            return "/api/\(version)/user/starred/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)"
        case .watchRepo(let login, let repoName, _),
             .unwatchRepo(let login, let repoName),
             .isWatchRepo(let login, let repoName):
            return "/api/\(version)/user/subscriptions/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)"
        case .repoStarsList(let login, let repoName, _, _):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/stargazers"
        case .repoWatchingsList(let login, let repoName, _, _):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/subscribers"
        case .repoForksList(let login, let repoName, _, _):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/forks"
        case .repoCommitsList(let login, let repoName, _, _):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/commits"
        case .recommendRepoList:
            return "/api/\(version)/projects/featured"
        case .popularRepoList:
            return "/api/\(version)/projects/popular"
        case .latestRepoList:
            return "/api/\(version)/projects/latest"
        case .searchRepos:
            return "/api/\(version)/search/repositories"
        case .searchUsers:
            return "/api/\(version)/search/users"
        case .searchIssues:
            return "/api/\(version)/search/issues"
        }
    }

    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .user,
             .userPublicRepos,
             .userFollower,
             .userFollowing,
             .userStars,
             .repoInfo,
             .isStarRepo,
             .isWatchRepo,
             .repoIssuesList,
             .repoForksList,
             .repoStarsList,
             .repoCommitsList,
             .repoWatchingsList,
             .recommendRepoList,
             .popularRepoList,
             .latestRepoList,
             .searchRepos,
             .searchUsers,
             .searchIssues:
            return .get
        case .forkRepo:
            return .post
        case .starRepo,
             .watchRepo:
            return .put
        case .unstarRepo,
             .unwatchRepo:
            return .delete
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
            return .requestParameters(parameters: ["access_token":GiteeAccessToken()],
                                      encoding: URLEncoding())
        case .userPublicRepos(_, let page, let per_page):
            return .requestParameters(parameters: ["type":"all",
                                                   "sort":"full_name",
                                                   "page":page,
                                                   "per_page":per_page],
                                      encoding: URLEncoding())
        case .userFollower(_, let page, let per_page),
             .userFollowing(_, let page, let per_page),
             .repoIssuesList(_, _, let page, let per_page),
             .repoWatchingsList(_, _, let page, let per_page),
             .repoForksList(_, _, let page, let per_page),
             .repoStarsList(_, _, let page, let per_page),
             .repoCommitsList(_, _,let page, let per_page) :
            return .requestParameters(parameters: ["page":page,
                                                   "per_page":per_page,
                                                   "access_token":GiteeAccessToken()],
                                      encoding: URLEncoding())
        case .userStars:
            return .requestParameters(parameters: ["access_token":GiteeAccessToken(),
                                                   "limit":20,
                                                   "sort":"created"],
                                      encoding: URLEncoding())
        case .repoInfo,
             .unstarRepo,
             .isStarRepo,
             .unwatchRepo,
             .isWatchRepo:
            return .requestParameters(parameters: ["access_token":GiteeAccessToken()],
                                      encoding: URLEncoding())
        case .recommendRepoList(let page, let per_page),
                .latestRepoList(let page, let per_page),
                .popularRepoList(let page, let per_page):
            return .requestParameters(parameters: ["page":page,
                                                   "per_page":per_page,
                                                   "access_token":GiteeAccessToken()],
                                      encoding: URLEncoding())
        case .starRepo,
             .forkRepo:
            return .requestParameters(parameters: ["access_token":GiteeAccessToken()],
                                      encoding: JSONEncoding())
        case .watchRepo(_,_,let watchType):
            return .requestParameters(parameters: ["access_token":GiteeAccessToken(),
                                                   "watch_type": watchType],
                                      encoding: JSONEncoding())
        case .searchIssues(let q, let page, let per_page),
                .searchUsers(let q, let page, let per_page),
                .searchRepos(let q, let page, let per_page):
            return .requestParameters(parameters: ["q":q,
                                                   "page":page,
                                                   "per_page":per_page,
                                                   "access_token":GiteeAccessToken()],
                                      encoding: URLEncoding())
            
        }
       
    }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        var acceptArray: [Int] = []
        acceptArray.append(contentsOf: Array(200..<300))
        acceptArray.append(contentsOf: Array(400..<500))
        return .customCodes(acceptArray)
    }

    /// The headers to be used in the request.
    var headers: [String: String]? {
        return ["Content-Type": "application/json;charset=UTF-8"]
    }
    
    /// resultType
    var resultType: ZLRestAPIResultType {
        switch self {
        case .user:
            return .object(parseWrapper: ZLGiteeUserModel.self)
        case .repoInfo:
            return .object(parseWrapper: ZLGiteeRepoModel.self)
        case .forkRepo:
            return .object(parseWrapper: ZLGiteeRepoModel.self)
        case .repoIssuesList,
                .searchIssues:
            return .array(parseWrapper: ZLGiteeIssueModel.self)
        case .repoWatchingsList,
             .repoStarsList,
             .searchUsers:
            return .array(parseWrapper: ZLGiteeUserModel.self)
        case .repoForksList,
                .searchRepos:
            return .array(parseWrapper: ZLGiteeRepoModel.self)
        case .popularRepoList,
                .recommendRepoList,
                .latestRepoList:
            return .array(parseWrapper: ZLGiteeRepoModelV3.self)
        case .repoCommitsList:
            return .array(parseWrapper: ZLGiteeCommitModel.self)
        default:
            return .data
        }
    }
}
