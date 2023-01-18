//
//  MusicViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 05/01/2023.
//

import RxSwift
import RxCocoa

final class MovieViewModel {

    //MARK: Normal variable
    var musicRelay: BehaviorRelay<[MySectionModel]> = .init(value: [])
    var trendingData: [SectionItem] = []
    var upcomingData: [SectionItem] = []

    var error: PublishRelay<String> = .init()
    var isLoading: PublishSubject<Bool> = .init()

    let bagModel: DisposeBag = DisposeBag()

    private func getApiTrending() -> Single<MovieResponse> {
        return ApiNetWorkManager.shared.request(.trending)
    }

    private func getApiUpcoming() -> Single<MovieResponse> {
        return ApiNetWorkManager.shared.request(.upcoming)
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
    func zipMovieData() {
        Single.zip(getApiTrending(), getApiUpcoming())
            .subscribe(onSuccess: { [weak self] trendingList, upcomingList in
                guard let this = self else { return }
                this.isLoading.onNext(true)
                this.musicRelay.accept([.init(header: .trending,
                                              items: this.checkTitle(data: trendingList.results ?? [])),
                                        .init(header: .upcoming,
                                              items: this.checkTitle(data: upcomingList.results ?? []))])
            }, onFailure: { [weak self] err in
                guard let this = self else { return }
                this.isLoading.onNext(true)
                this.error.accept(String(describing: err))
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
