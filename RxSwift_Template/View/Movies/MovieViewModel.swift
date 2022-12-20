//
//  MovieViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieViewModel {
    var movies: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    private var bag: DisposeBag = DisposeBag()
    var loadingData: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    func networkingRX<T: Decodable>(url: String) -> Single<T> {
        return Single.create { single -> Disposable in
            let response = Observable<String>.of(url)
                .map { urlString -> URL in
                    return URL(string: urlString)!
                }
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
                        single(.failure("Fail parse data" as! Error))
                    }
                }, onError: { error in
                    print(error.localizedDescription)
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

    func getMovies() -> Single<MovieResponse> {
        let urlMusic: String = "https://api.themoviedb.org/3/movie/upcoming?api_key=216da5281cfea1ed5f0ba025ace614b4&language=en-US&page=1"
        return networkingRX(url: urlMusic)
    }

    func searchMovies(_ query: String) -> Single<MovieResponse> {
        let urlMusic: String = "https://api.themoviedb.org/3/search/movie?api_key=216da5281cfea1ed5f0ba025ace614b4&language=en-US&query=\(query)&page=1&include_adult=false"
        return networkingRX(url: urlMusic)
    }

    func viewModelForItem(element: Movie) -> MovieCellViewModel {
        return MovieCellViewModel(movie: element)
    }
}
