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
    
    func request<T: Decodable>(_ target: ApiTarget) -> Single<T> {
        return Single<T>.create { [weak self] single -> Disposable in
            guard let this = self else {
                return Disposables.create()
            }
            this.provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let modal: T = try JSONDecoder().decode(T.self, from: response.data)
                        single(.success(modal))
                    } catch {
                        single(.failure(error))
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
