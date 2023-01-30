//
//  ApiTarget.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import Moya

enum ApiTarget {
    case trending
    case upcoming
}

extension ApiTarget: TargetType {
    var baseURL: URL {
        guard let baseUrl: URL = URL(string: "https://api.themoviedb.org/3") else {
            fatalError(ApiError.pathError.localizedDescription)
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .upcoming:
            return "/movie/upcoming"
        case .trending:
            return "trending/all/day"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .trending, .upcoming:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .trending, .upcoming:
            return .requestParameters(parameters: ["api_key": "216da5281cfea1ed5f0ba025ace614b4"], encoding: URLEncoding.queryString)
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
