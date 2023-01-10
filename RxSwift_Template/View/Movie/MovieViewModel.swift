//
//  MusicViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 05/01/2023.
//

import RxSwift
import RxCocoa

final class MovieViewModel {

    var musicRelay: BehaviorRelay<[MySectionModel]> = .init(value: [])
    var trendingData: [SectionItem] = []
    var upcomingData: [SectionItem] = []

    let bagModel: DisposeBag = DisposeBag()

    private func getApiMusic() -> Single<MovieResponse> {
        return ApiManager.shared.networkingRX(url: .trending)
    }

    private func getApiUpcoming() -> Single<MovieResponse> {
        return ApiManager.shared.networkingRX(url: .upcoming)
    }

    func viewModelForTrending(at element: Movie) -> TitledCellViewModel {
        return TitledCellViewModel(movie: element)
    }

    func viewModelForUpcoming(at element: Movie) -> NonTitleCellViewModel {
        return NonTitleCellViewModel(movie: element)
    }
}

// MARK: Handle data apis
extension MovieViewModel {
    func getMusicData() {
        getApiMusic()
            .subscribe(onSuccess: { [weak self] movies in
            guard let this = self else { return }
            let listMovie = movies.results ?? []
                print(listMovie.count)
            for movie in listMovie {
                if (movie.title ?? "").isEmpty {
                    this.trendingData.append(.nonTilte(item: movie))
                    this.upcomingData.append(.nonTilte(item: movie))
                } else {
                    this.trendingData.append(.titled(item: movie))
                }
            }
            this.musicRelay.accept([.init(header: .trending, items: this.trendingData),
                                    .init(header: .upcoming, items: this.upcomingData)])
        }) .disposed(by: bagModel)
    }

    func zipMovieData() {
        Single.zip(getApiMusic(), getApiUpcoming())
            .subscribe(onSuccess: { [weak self] trendingList, upcomingList in
                guard let this = self else { return }
                this.musicRelay.accept([.init(header: .trending,
                                              items: this.checkTitle(data: trendingList.results ?? [])),
                                        .init(header: .upcoming,
                                              items: this.checkTitle(data: upcomingList.results ?? []))])
            }, onFailure: { error in
                print(ApiError.error(error.localizedDescription))
            })
            .disposed(by: bagModel)
    }

    private func checkTitle(data: [Movie]) -> [SectionItem] {
        var items: [SectionItem] = []
        for movie in data {
            (movie.title ?? "").isEmpty ? items.append(.nonTilte(item: movie)) : items.append(.titled(item: movie))
        }
        return items
    }
}
