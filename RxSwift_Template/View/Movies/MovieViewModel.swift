//
//  MovieViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import RxSwift
import RxCocoa

final class MovieViewModel {

    var movies: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    var loadingData: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var bag = DisposeBag()

    func searchMovies(_ query: String) -> Single<MovieResponse> {
        let urlSearch: String = "\(Define.baseUrl)\(Define.searchPath)?\(Define.key)&language=en-US&query=\(query)"
        let urlMovie: String = "\(Define.baseUrl)\(Define.upcomingPath)?\(Define.key)&language=en-US"
        let urlString: String = query.isEmpty ? urlMovie : urlSearch
        return ApiManager.shared.networkingRX(url: urlString)
    }

    func viewModelForItem(element: Movie) -> MovieCellViewModel {
        return MovieCellViewModel(movie: element)
    }

    func searchData(_ query: String) {
        let searchText = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        loadingData.onNext(false)
        searchMovies(searchText ?? "")
            .subscribe(onSuccess: { [weak self] data in
                guard let this = self else { return }
                this.loadingData.onNext(true)
                this.movies.onNext(data.results ?? [])
            }, onFailure: { _ in
                self.loadingData.onNext(true)
            })
            .disposed(by: bag)
    }
}

extension MovieViewModel {
    private struct Define {
        static var baseUrl: String = "https://api.themoviedb.org/3"
        static var upcomingPath: String = "/movie/upcoming"
        static var searchPath: String = "/search/movie"
        static var key: String = "api_key=216da5281cfea1ed5f0ba025ace614b4"
    }
}
