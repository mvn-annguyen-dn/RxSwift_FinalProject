//
//  ApiTarget.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import Moya

enum LoginTarget {
    case example
}

extension LoginTarget: TargetType {
    
    var baseURL: URL {
        return ApiNetWorkManager.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .example:
            return "most-played/10/albums.json/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .example:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .example:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ApiNetWorkManager.shared.defaultHTTPHeaders
        }
    }
}
