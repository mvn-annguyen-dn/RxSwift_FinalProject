//
//  ApiTarget.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import Moya

enum ApiTarget {
    case login(userName: String, password: String)
}

extension ApiTarget: TargetType {

    var baseURL: URL {
        return URL(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json").unsafelyUnwrapped
    }

    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .login(let userName, let password):
            return .requestParameters(parameters: ["user": userName,
                                                   "pw": password], encoding: URLEncoding.default)
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
