//
//  MovieViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

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

final class MovieViewModel {
    var movies: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    private var bag: DisposeBag = DisposeBag()
    var loadingData: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
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

    func searchMovies(_ query: String) -> Single<MovieResponse> {
        let urlMusic: String = "https://api.themoviedb.org/3/search/movie?api_key=216da5281cfea1ed5f0ba025ace614b4&language=en-US&query=\(query)&page=1&include_adult=false"
        if query.isEmpty {
            return networkingRX(url: Define.baseUrl)
        } else {
            return networkingRX(url: urlMusic)
        }
    }

    func viewModelForItem(element: Movie) -> MovieCellViewModel {
        return MovieCellViewModel(movie: element)
    }
}

extension MovieViewModel {
    private struct Define {
        static var baseUrl: String = "https://api.themoviedb.org/3/movie/upcoming?api_key=216da5281cfea1ed5f0ba025ace614b4&language=en-US&page=1"
    }
}
