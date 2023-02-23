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
    case addCart(id: Int, quantity: Int)
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
        case .addCart(let id, _):
            return "cart/add/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .shop, .recommend, .popular:
            return .get
        case .addCart:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .shop, .recommend, .popular:
            return .requestPlain
        case .addCart(id: _, quantity: let quantity):
            return .requestParameters(parameters: ["quantity": "\(quantity)"], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ApiNetWorkManager.shared.defaultHTTPHeadersWithToken
        }
    }
}
