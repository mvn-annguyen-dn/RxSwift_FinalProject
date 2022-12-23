//
//  RecommendCollectionViewCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import Foundation
import RxCocoa
import RxSwift

final class RecommendCollectionViewCellViewModel {
    
    let bag: DisposeBag = DisposeBag()
    var musicBehaviorRelay: BehaviorRelay<Music?> = .init(value: nil)

    init(music: Music) {
        musicBehaviorRelay.accept(music)
    }
}
