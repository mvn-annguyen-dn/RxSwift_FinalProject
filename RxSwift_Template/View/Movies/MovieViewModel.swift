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
    var loadingData: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    func searchMovies(_ query: String) -> Single<MovieResponse> {
        let urlMusic: String = "https://api.themoviedb.org/3/search/movie?api_key=216da5281cfea1ed5f0ba025ace614b4&language=en-US&query=\(query)&page=1&include_adult=false"
        let urlString: String = query.isEmpty ? Define.baseUrl : urlMusic

        return ApiManager.shared.networkingRX(url:urlString)
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
