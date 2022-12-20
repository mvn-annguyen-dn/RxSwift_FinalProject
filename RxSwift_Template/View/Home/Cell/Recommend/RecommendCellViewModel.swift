//
//  RecommendCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class RecommendCellViewModel {

    var musicBehaviorRelay: BehaviorRelay<[Music]> = .init(value: [])

    func getApiMusic() -> Single<FeedResults> {
        return ApiManager.shared.loadAPI(method: .get)
    }

    func getDataRecommendCell(index: Int) -> RecommendCollectionViewCellViewModel {
        return RecommendCollectionViewCellViewModel(music: musicBehaviorRelay.value[index])
    }
}
