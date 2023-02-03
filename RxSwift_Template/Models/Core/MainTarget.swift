//
//  MainTarget.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import Moya

enum MainTarget {
    #warning("Handle Later")
}

extension MainTarget: TargetType {
    
    var baseURL: URL {
        return ApiNetWorkManager.shared.baseURL
    }
    
    var path: String {
        switch self {
            #warning("Handle Later")
        }
    }
    
    var method: Moya.Method {
        switch self {
            #warning("Handle Later")
        }
    }
    
    var task: Moya.Task {
        switch self {
            #warning("Handle Later")
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ApiNetWorkManager.shared.defaultHTTPHeadersWithToken
        }
    }
}
