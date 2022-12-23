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
    
    func loadApiMusic() -> Single<FeedResults> {
        return Single<FeedResults>.create { [weak self] single -> Disposable in
            guard let this = self else {
                return Disposables.create {}
            }
            this.getApiMusic().subscribe { result in
                switch result {
                case .success(let value):
                    self?.musicBehaviorRelay.accept(value.results ?? [])
                    single(.success(value))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            .disposed(by: this.bag)
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
    
    func getDataRecommendCell(index: Int) -> RecommendCellViewModel {
        return RecommendCellViewModel(music: musicBehaviorRelay.value)
    }
}
