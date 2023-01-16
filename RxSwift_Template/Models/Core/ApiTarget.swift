//
//  ApiTarget.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import Moya

enum ApiTarget {
    case getMusic
}

extension ApiTarget: TargetType {
    var baseURL: URL {
        guard let baseUrl: URL = URL(string: ConfigNetWork.baseURL) else {
            fatalError(ApiError.pathError.localizedDescription)
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        default: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json; charset=utf-8"
            ]
        }
    }
    
    
}

enum ApiError: Error {
    case pathError
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .pathError:
            return "URL not found"
        case .error(let errorMessage):
            return errorMessage
        }
    }
}

struct ConfigNetWork {
    public static let baseURL: String = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
}
