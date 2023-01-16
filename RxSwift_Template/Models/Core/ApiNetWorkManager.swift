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
//        let configuration =  URLSessionConfiguration.default
//        let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
//        return MoyaProvider<APITarget>(session: session)
    }()
    
    func request<T: Decodable>(_ type: T.Type, _ target: ApiTarget) -> Single<T> {
        return provider.rx.request(target).filterSuccessfulStatusCodes()
            .map { response in
                do {
                    return try JSONDecoder().decode(T.self, from: response.data)
                } catch {
                    throw APIError.error("FAILURE API")
                }
            }
    }
}
