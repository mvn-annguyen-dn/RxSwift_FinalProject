//
//  State.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 11/01/2023.
//

import RxSwift
import RxCocoa

#warning("WIP State")
struct State {
    // MARK: Input MovieViewModel
    var moviesStateRelay: BehaviorRelay<[MySectionModel]>
}

//protocol Hook {
//    func useState
//    func useEffect(_: () -> (Void))
//}

protocol MovieRepo {
    func getMoviesTreding() -> Single<MovieResponse>
    func getMoviesUpcoming() -> Single<MovieResponse>
}

final class MovieRepoImpl: MovieRepo {
    func getMoviesTreding() -> RxSwift.Single<MovieResponse> {
        ApiNetWorkManager.shared.request(MovieResponse.self, .trending)
    }
    
    func getMoviesUpcoming() -> RxSwift.Single<MovieResponse> {
        ApiNetWorkManager.shared.request(MovieResponse.self, .upcoming)
    }
}

final class MovieUseCase {
    private final let movieRepo: MovieRepo

    init(movieRepo: MovieRepo) {
        self.movieRepo = movieRepo
    }
}
