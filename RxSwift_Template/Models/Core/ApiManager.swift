//
//  ApiManager.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

typealias APICompletion = (APIResult) -> Void

enum APIResult {
    case success
    case failure(Error)
}

class ApiManager {
    static let shared: ApiManager = ApiManager()
    let baseUrl: String = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
    let bag: DisposeBag = DisposeBag()
    
    func loadAPI<T: Decodable>(method: Method) -> Single<T> {
        return Single<T>.create { [weak self] single -> Disposable in
            guard let this = self else {
                return Disposables.create()
            }
            let observable = Observable<String>.just(this.baseUrl)
                .compactMap { URL(string: $0) }
                .map { path -> URLRequest in
                    var request = URLRequest(url: path)
                    request.httpMethod = method.rawValue
                    request.addValue("application/json", forHTTPHeaderField: "Content-type")
                    return request
                }
                .flatMap { urlRequest -> Observable<(response: HTTPURLResponse, data: Data)> in
                    return URLSession.shared.rx.response(request: urlRequest)
                }
            
            observable.subscribe { (response, data) in
                do {
                    let modal: T = try JSONDecoder().decode(T.self, from: data)
                    single(.success(modal))
                } catch {
                    single(.failure(APIError.error("Fail parse data")))
                }
            } onError: { error in
                single(.failure(ApiError.pathError))
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: this.bag)
            
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
}

extension ApiManager {
    enum Method: String {
        case get
        case post
        case put
        case delete
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
