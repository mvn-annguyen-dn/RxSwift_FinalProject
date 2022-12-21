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

    var bag: DisposeBag = DisposeBag()
    var musicBehaviorRelays: BehaviorRelay<[Music]> = .init(value: [])
    
    init(music: [Music]) {
        musicBehaviorRelays.accept(music)
    }

    func getDataRecommendCollectionCell(indexPath: IndexPath) -> RecommendCollectionViewCellViewModel {
        return RecommendCollectionViewCellViewModel(music: musicBehaviorRelays.value[indexPath.row])
    }
}
