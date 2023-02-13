//
//  ApiTarget.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import Moya

enum LoginTarget {
    case example
    case login(userName: String, passWord: String)
}

extension LoginTarget: TargetType {
    
    var baseURL: URL {
        return ApiNetWorkManager.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .example:
            return "most-played/10/albums.json/"
        case .login:
            return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .example:
            return .get
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .example:
            return .requestPlain
        case .login(let userName, let passWord):
            return .requestParameters(parameters: ["email": userName, "password": passWord], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ApiNetWorkManager.shared.defaultHTTPHeaders
        }
    }
}
