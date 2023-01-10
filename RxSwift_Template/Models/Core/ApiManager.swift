//
//  ApiManager.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 05/01/2023.
//

import RxSwift

enum UrlRequest {
    case upcoming
    case trending
    
    var url: String {
        switch self {
        case .upcoming:
            return "https://api.themoviedb.org/3/movie/upcoming?api_key=216da5281cfea1ed5f0ba025ace614b4"
        case .trending:
            return "https://api.themoviedb.org/3/trending/all/day?api_key=216da5281cfea1ed5f0ba025ace614b4"
        }
    }
}

final class ApiManager {
    static var shared: ApiManager = ApiManager()
    
    var bag = DisposeBag()
    
    func networkingRX<T: Decodable>(url: UrlRequest) -> Single<T> {
        return Single.create { single -> Disposable in
            guard let url = URL(string: url.url) else {
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

final class DowloadImage {
    static var shared: DowloadImage = DowloadImage()
    
    var bag = DisposeBag()
    
    func downloadImage(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.pathError)
                return Disposables.create()
            }
            let urlRequest = URLRequest(url: url)
            URLSession.shared.rx
                .response(request: urlRequest)
                .subscribe(onNext: { data in
                    let image = UIImage(data: data.data)
                    observer.onNext(image)
                }, onError: { _ in
                    observer.onError(ApiError.error("Download Error"))
                }, onCompleted: {
                    print("onCompleted")
                }).disposed(by: self.bag)
            return Disposables.create()
        }
        .subscribe(on: MainScheduler.instance)
    }
}
