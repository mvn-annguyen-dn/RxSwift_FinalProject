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
    private let multiProvider: MoyaProvider<MultiTarget> = {
        return MoyaProvider<MultiTarget>()
    }()
    
    func request<T: Decodable>(_ type: T.Type, _ target: MultiTarget) -> Single<T> {
        return multiProvider.rx.request(.target(target))
            .filterStatusCodes()
            .map { response in
                do {
                    return try JSONDecoder().decode(T.self, from: response.data)
                } catch {
                    throw ApiError.noData
                }
            }
            .catch { error in
                throw error
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


public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func filterStatusCodes() -> Single<Element> {
        flatMap { res in
            switch res.statusCode {
            case 200...299:
                return .just(res)
            case 400...499:
                throw ApiError.badRequest
            default:
                throw ApiError.unknown
            }
        }
    }
}
