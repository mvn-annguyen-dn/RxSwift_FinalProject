//
//  HomeViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewModel {
    
    let bag: DisposeBag = DisposeBag()
    var musicBehaviorRelay: BehaviorRelay<[Music]> = .init(value: [])
    
    func getApiMusic() -> Single<FeedResults> {
        return ApiManager.shared.loadAPI(method: .get)
    }

    func loadApiMusic(completion: @escaping APICompletion) {
        getApiMusic().subscribe { data in
            self.musicBehaviorRelay.accept(data.results ?? [])
            completion(.success)
        } onFailure: { error in
            completion(.failure(error))
        }
        .disposed(by: bag)
    }
    
    func getDataRecommendCell(indexPath: IndexPath) -> RecommendCellViewModel {
        return RecommendCellViewModel(music: musicBehaviorRelay.value)
    }
}
