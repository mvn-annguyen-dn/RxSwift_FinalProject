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

    //MARK: Singleton
    static let shared: ApiNetWorkManager = ApiNetWorkManager()
    
    // MARK: Properties

    // Provider
    private let multiProvider: MoyaProvider<MultiTarget> = {
        return MoyaProvider<MultiTarget>()
    }()

    var baseURL: URL {
        guard let baseUrl: URL = URL(string: "http://127.0.0.1:8000/api/v1/user/") else {
            return URL(string: "").unsafelyUnwrapped
        }
        return baseUrl
    }

    // Header Of Request
    var defaultHTTPHeaders: [String: String] {
        return ["Content-type": "application/json"]
    }

    var defaultHTTPHeadersWithToken: [String: String] {
        return [
            "Content-type": "application/json",
            "Authorization": "Bearer \(Session.shared.token)"]
    }
    
    // Request
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

// MARK: Define Api Error
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
