//
//  MainTarget.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import Moya

enum MainTarget {
    case shop
    case recommend
    case popular
}

extension MainTarget: TargetType {
    
    var baseURL: URL {
        return ApiNetWorkManager.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .shop:
            return "shop"
        case .recommend:
            return "product/random"
        case .popular:
            return "product/new"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .shop, .recommend, .popular:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .shop, .recommend, .popular:
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
