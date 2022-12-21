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
    
    func getDataRecommendCell(indexPath: IndexPath) -> RecommendCellViewModel {
        return RecommendCellViewModel(music: musicBehaviorRelay.value)
    }
}
