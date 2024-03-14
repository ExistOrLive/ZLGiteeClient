//
//  Request.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2024/2/26.
//

import Foundation
import Moya
import Alamofire
import HandyJSON

// MARK: - ZLRestAPIResultParseProtocol 处理协议
protocol ZLRestAPIResultParseProtocol {
    func parseData(_: Result<Moya.Response, MoyaError>) -> (Bool,Any?,String)
}

// MARK: - ZLRestAPIResultType
enum ZLRestAPIResultType {
    case data           // 返回 Data
    case jsonObject     // 返回 Dictionary或Array
    case string         // 返回 String
    case object(parseWrapper: HandyJSON.Type) // 返回 Object
    case array(parseWrapper: HandyJSON.Type)  // 返回数组
    case custom(parseWrapper: ZLRestAPIResultParseProtocol) // 自定义返回
    
    func parseResult(_ result: Result<Moya.Response, MoyaError>) -> (Bool,Any?,String) {
        switch result {
        case .failure(let error):
            return (false,"",error.localizedDescription)
        case .success(let response):
            if response.statusCode >= 200, response.statusCode < 300 {
                switch self {
                case .data:
                    return (true,response.data,"")
                case .jsonObject:
                    do {
                        let json = try response.mapJSON()
                        return (true,json,"")
                    } catch {
                        return (false,nil,error.localizedDescription)
                    }
                case .string:
                    do {
                        let str = try response.mapString()
                        return (true,str,"")
                    } catch {
                        return (false,nil,error.localizedDescription)
                    }
                case .object(let parseWrapper):
                    do {
                        let json = try response.mapJSON() as? [String:Any]
                        let obj = parseWrapper.deserialize(from: json)
                        return (true,obj,"")
                    } catch {
                        return (false,nil,error.localizedDescription)
                    }
                case .array(let parseWrapper):
                    do {
                        let json = try response.mapJSON() as? [Any]
                        let objArray = json?.compactMap({ dic in
                            return parseWrapper.deserialize(from: dic as? [String:Any])
                        })
                        return (true,objArray,"")
                    } catch {
                        return (false,nil,error.localizedDescription)
                    }
                case .custom(let parseWrapper):
                    return parseWrapper.parseData(result)
                }
            } else {
                let json = try? response.mapJSON() as? [String:Any]
                let messgae = json?["message"] as? String ?? ""
                return (false,nil,messgae)
            }
        }
    }
}

// MARK: - RestTargetType  扩展 resultType
protocol RestTargetType: Moya.TargetType {
    var resultType: ZLRestAPIResultType { get }
}

// MARK: - 扩展 MoyaProviderType 支持 resultType
extension MoyaProviderType {
    
    @discardableResult
    func requestRest(_ target: Target,
                     callbackQueue: DispatchQueue? = .none,
                     progress: ProgressBlock? = .none,
                     completion: @escaping ((Bool,Any?,String) -> Void)) -> Cancellable {
        request(target,
                callbackQueue: callbackQueue,
                progress: progress) { result in
            
            if case .success(let response) = result,
               response.statusCode == 401 {
                /// 401 token 失效
                NotificationCenter.default.post(name: AccessTokenInvalidNotification,
                                                object: nil)
            }
            
        
            if let restTargetType = target as? RestTargetType {
                
                let (result,data,errorMsg) = restTargetType.resultType.parseResult(result)
                completion(result,data,errorMsg)
                
            } else {
                
                switch result {
                case .failure(let error):
                    return completion(false,"",error.localizedDescription)
                case .success(let response):
                    return completion(true, response.data, "")
                }
            }
            
        }
    }
}
