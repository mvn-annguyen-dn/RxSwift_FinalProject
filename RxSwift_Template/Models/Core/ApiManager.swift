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

class ApiManager {
    static let shared: ApiManager = ApiManager()
    let baseUrl: String = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
    let bag: DisposeBag = DisposeBag()

    func loadAPI<T: Decodable>(method: Method) -> Single<T> {
        return Single<T>.create { [weak self] single -> Disposable in
            guard let this = self,
                  let path = URL(string: this.baseUrl) else {
                single(.failure(APIError.pathError))
                return Disposables.create()
            }
            let observable = Observable<URL>.just(path)
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
                single(.failure(error))
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
    
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(nil)
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
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
