//
//  RecommendCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 08/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class RecommendCellViewModel {
    
    var recommends: BehaviorRelay<[Product]> = .init(value: [])
    
    init(recommends: [Product]) {
        self.recommends.accept(recommends)
    }
    
    func viewModelForItem(recommendProduct: Product) -> RecommendCollectionViewCellViewModel {
        return RecommendCollectionViewCellViewModel(recommend: recommendProduct)
    }
}
