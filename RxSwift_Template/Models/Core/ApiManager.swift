//
//  ApiManager.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 21/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class ApiManager {
    static var shared: ApiManager = ApiManager()
    
    var bag = DisposeBag()

    func networkingRX<T: Decodable>(url: String) -> Single<T> {
        return Single.create { single -> Disposable in
            guard let url = URL(string: url) else {
                single(.failure(APIError.pathError))
                return Disposables.create()
            }
            let response = Observable<URL>.of(url)
                .map { url -> URLRequest in
                    return URLRequest(url: url)
                }
                .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                    return URLSession.shared.rx.response(request: request)
                }
            
            response
                .filter { response, _ -> Bool in
                    return 200..<300 ~= response.statusCode
                }
                .subscribe(onNext: { (res, data) in
                    do {
                        let modal: T = try JSONDecoder().decode(T.self, from: data)
                        single(.success(modal))
                    } catch {
                        single(.failure(ApiError.error("Fail response")))
                    }
                }, onError: { _ in
                    single(.failure(APIError.error("Fail parse data")))
                }, onCompleted: {
                    print("Completed")
                }, onDisposed: {
                    print("disposed")
                })
                .disposed(by: self.bag)
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
}

enum APIError: Error {
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
