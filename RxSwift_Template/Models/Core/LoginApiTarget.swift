//
//  LoginApiTarget.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 31/01/2023.
//

import Moya

enum LoginApiTarget {
    case login
}

extension LoginApiTarget: TargetType {

    var baseURL: URL {
        guard let baseUrl: URL = URL(string: "http://127.0.0.1:8000/api/v1/user/") else {
            fatalError(ApiError.badRequest.localizedDescription)
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
        case .login:
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
