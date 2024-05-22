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

extension Dictionary where Key == String, Value == Any? {
    func toParameters() -> [String: Any] {
        self.compactMapValues { value in
            return value
        }
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
    
    case repoBranchList(login: String,
                        repoName: String,
                        page: Int,
                        per_page: Int = 20,
                        sort: String = "updated",
                        direction: String = "desc")
    
    case repoContentList(login: String,
                         repoName: String,
                         path: String,
                         ref: String?)
    
    case latestRepoList(page: Int, per_page: Int)
    case popularRepoList(page: Int, per_page: Int)
    case recommendRepoList(page: Int, per_page: Int)
    
    case searchRepos(q: String, page: Int, per_page: Int)
    case searchUsers(q: String, page: Int, per_page: Int)
    case searchIssues(q: String, page: Int, per_page: Int)
    
    case repoReadMe(login: String, repoName: String, ref: String?)
    
    case markdownRender(markdown: String)
    
    case oauthUserRepoList(page: Int,
                           per_page: Int,
                           sort: String = "full_name",
                           q: String? = nil ,
                           direction: String? = nil ,
                           visibility: String? = nil ,
                           affiliation: String? = nil)
    
    case oauthUserOrgList(page: Int,
                          per_page: Int,
                          admin: Bool = false)
    
    case userContributionData(login: String)
    
    case userReceivedEvent(loginName: String,
                           limit: Int = 20,
                           prev_id: Int? = nil)
    
    case userEvent(loginName: String,
                   limit: Int = 20,
                   prev_id: Int? = nil)
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
        case .repoBranchList(let login,
                             let repoName, _, _ , _, _ ):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/branches"
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
        case .oauthUserRepoList:
            return "/api/\(version)/user/repos"
        case .oauthUserOrgList:
            return "/api/\(version)/user/orgs"
        case .userContributionData(let login):
            return "/\(login.urlPathEncoding)"
        case .repoReadMe(let login,let repoName,_):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/readme"
        case .repoContentList(let login, let repoName, let path, _):
            return "/api/\(version)/repos/\(login.urlPathEncoding)/\(repoName.urlPathEncoding)/contents/\(path.urlPathEncoding)"
        case .markdownRender:
            return "/api/\(version)/markdown"
        case .userReceivedEvent(let loginName,_, _):
            return "/api/\(version)/users/\(loginName.urlPathEncoding)/received_events"
        case .userEvent(let loginName,_, _):
            return "/api/\(version)/users/\(loginName.urlPathEncoding)/events"
        }
    }

    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .forkRepo,
                .markdownRender:
            return .post
        case .starRepo,
             .watchRepo:
            return .put
        case .unstarRepo,
             .unwatchRepo:
            return .delete
        default:
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
        case .repoBranchList(_, _, let page,let per_page,let sort,let direction):
            return .requestParameters(parameters: ["page":page,
                                                   "per_page":per_page,
                                                   "sort": sort,
                                                   "direction": direction,
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
        case .oauthUserRepoList(let page,let per_page,let sort,let q,let direction,let visibility,let affiliation):
            return .requestParameters(parameters: ["q":q,
                                                   "page":page,
                                                   "per_page":per_page,
                                                   "sort": sort,
                                                   "direction": direction,
                                                   "visibility": visibility,
                                                   "affiliation": affiliation,
                                                   "access_token":GiteeAccessToken()].toParameters(),
                                      encoding: URLEncoding())
        case .oauthUserOrgList(let page,let per_page,let admin):
            return .requestParameters(parameters: ["page":page,
                                                   "per_page":per_page,
                                                   "admin": admin,
                                                   "access_token":GiteeAccessToken()].toParameters(),
                                      encoding: URLEncoding())
        case .userContributionData:
            return .requestPlain
        case .repoReadMe(_, _ ,let ref):
            return .requestParameters(parameters: ["ref": ref,
                                                   "access_token":GiteeAccessToken()].toParameters(),
                                      encoding: URLEncoding())
        case .repoContentList(_, _ , _ , let ref):
            return .requestParameters(parameters: ["ref": ref,
                                                   "access_token":GiteeAccessToken()].toParameters(),
                                      encoding: URLEncoding())
        case .markdownRender(let markdown):
            return .requestParameters(parameters: ["access_token":GiteeAccessToken(),
                                                   "text": markdown],
                                      encoding: JSONEncoding())
        case .userReceivedEvent(_, let limit, let prev_id),
                .userEvent(_,let limit, let prev_id) :
            return .requestParameters(parameters: ["access_token":GiteeAccessToken(),
                                                   "limit":limit,
                                                   "prev_id": prev_id].toParameters(),
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
        switch self {
        case .userContributionData:
            return nil
        default:
            return ["Content-Type": "application/json;charset=UTF-8"]
        }
        
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
                .searchRepos,
                .oauthUserRepoList:
            return .array(parseWrapper: ZLGiteeRepoModel.self)
        case .popularRepoList,
                .recommendRepoList,
                .latestRepoList:
            return .array(parseWrapper: ZLGiteeRepoModelV3.self)
        case .repoCommitsList:
            return .array(parseWrapper: ZLGiteeCommitModel.self)
        case .oauthUserOrgList:
            return .array(parseWrapper: ZLGiteeOrgModel.self)
        case .repoReadMe:
            return .object(parseWrapper: ZLGiteeFileContentModel.self)
        case .markdownRender:
            return .string
        case .repoBranchList:
            return .array(parseWrapper: ZLGiteeBranchModel.self)
        case .repoContentList:
            return .array(parseWrapper: ZLGiteeFileContentModel.self)
        case .userReceivedEvent,
                .userEvent:
            return .array(parseWrapper: ZLGiteeEventModel.self)
        default:
            return .data
        }
    }
}
