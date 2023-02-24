//
//  PopularCollectionViewCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 09/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class PopularCollectionViewCellViewModel {

    var popular: BehaviorRelay<Product?> = .init(value: nil)
    
    init(popular: Product?) {
        self.popular.accept(popular)
    }
}
