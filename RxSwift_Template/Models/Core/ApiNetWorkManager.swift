//
//  ApiNetWorkManager.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import RxSwift
import Moya
import RxCocoa

final class ApiNetWorkManager {
    static let shared: ApiNetWorkManager = ApiNetWorkManager()

    // Provider
    private let provider: MoyaProvider<ApiTarget> = {
        return MoyaProvider<ApiTarget>()
    }()

    func request<T: Decodable>(_ type: T.Type, _ target: ApiTarget) -> Single<T> {
        return provider.rx.request(target)
            .map { response in
                switch response.statusCode {
                case 200...299:
                    do {
                        return try JSONDecoder().decode(T.self, from: response.data)
                    } catch {
                        throw ApiError.noData
                    }
                case 400...499:
                    throw ApiError.badRequest
                default:
                    throw ApiError.unknown
                }
            }
    }
}

enum ApiError: Error {
    case noData
    case invalidResponse
    case badRequest
    case parseError
    case noInternet
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .noInternet:
            return "No Internet"
        case .noData:
            return "No data"
        case .invalidResponse:
            return "Invalid Response"
        case .badRequest:
            return "Bad request"
        case .parseError:
            return "Parse Json Error"
        case .unknown:
            return "Unknown Error"
        }
    }
}
