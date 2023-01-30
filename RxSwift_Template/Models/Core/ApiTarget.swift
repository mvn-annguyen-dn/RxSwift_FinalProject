//
//  ApiTarget.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import Moya
import RxSwift

enum ApiTarget {
    case products
}

extension ApiTarget: TargetType {
    var baseURL: URL {
        guard let baseUrl: URL = URL(string: "http://127.0.0.1:8000/api/v1/user/") else {
            fatalError(ApiError.pathError.localizedDescription)
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .products:
            return "product/new"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .products:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json; charset=utf-8",
                "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL3YxL3VzZXIvbG9naW4iLCJpYXQiOjE2NzM5MjU1NTcsImV4cCI6MTcwNTQ2MTU1NywibmJmIjoxNjczOTI1NTU3LCJqdGkiOiJsckJybDZzMVladGQ5Yzk4Iiwic3ViIjoiMjYiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.rZ0Yty5fyfD0sVUWwYmaU0lLK5LC0FjFhlgEBfuWle4"
            ]
        }
    }
    
    
}

enum ApiError: Error {
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
