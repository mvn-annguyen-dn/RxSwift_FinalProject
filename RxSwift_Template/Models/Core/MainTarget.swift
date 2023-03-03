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
    case cart
    case updateCart(id: Int, quantity: Int)
    case deleteCart(id: Int)
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
        case .cart:
            return "cart"
        case .updateCart(id: let id, quantity: _):
            return "cart/update/\(id)"
        case .deleteCart(id: let id):
            return "cart/delete/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .shop, .recommend, .popular, .cart:
            return .get
        case .updateCart:
            return .patch
        case .deleteCart:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .shop, .recommend, .popular, .cart, .deleteCart:
            return .requestPlain
        case .updateCart(id: _, quantity: let quantity):
            return .requestParameters(parameters: ["quantity": "\(quantity)"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ApiNetWorkManager.shared.defaultHTTPHeadersWithToken
        }
    }
}
