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
        return provider.rx.request(target).filterSuccessfulStatusCodes()
            .map { response in
                do {
                    return try JSONDecoder().decode(T.self, from: response.data)
                } catch {
                    throw ApiError.error("Failure parse data")
                }
            }
    }
}

final class DowloadImage {
    static var shared: DowloadImage = DowloadImage()
    
    var bag = DisposeBag()
    
    func downloadImage(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(ApiError.pathError)
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
