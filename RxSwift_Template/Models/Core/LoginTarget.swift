//
//  ApiTarget.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import Moya

enum LoginTarget {
    case login(userName: String, password: String)
}

extension LoginTarget: TargetType {
    
    var baseURL: URL {
        guard let baseUrl: URL = URL(string: "http://127.0.0.1:8000/api/v1/user/") else {
            fatalError(ApiError.unknown.localizedDescription)
        }
        return baseUrl

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

