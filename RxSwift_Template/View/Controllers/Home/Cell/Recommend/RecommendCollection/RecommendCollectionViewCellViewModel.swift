//
//  RecommendCollectionViewCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 09/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class RecommendCollectionViewCellViewModel {

    var recommend: BehaviorRelay<Product?> = .init(value: nil)
    
    init(recommend: Product?) {
        self.recommend.accept(recommend)
    }
}
