//
//  MainTarget.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import Moya

enum MainTarget {
    #warning("Handle Later")
    case search
}

extension MainTarget: TargetType {
    
    var baseURL: URL {
        return ApiNetWorkManager.shared.baseURL
    }
    
    var path: String {
        switch self {
            #warning("Handle Later")
        case .search:
            return "product"
        }
    }
    
    var method: Moya.Method {
        switch self {
            #warning("Handle Later")
        case .search:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            #warning("Handle Later")
        case .search:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ApiNetWorkManager.shared.defaultHTTPHeadersWithToken
        }
    }
}
