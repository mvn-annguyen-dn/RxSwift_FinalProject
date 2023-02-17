//
//  PopularCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 08/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class PopularCellViewModel {
    
    var populars: BehaviorRelay<[Product]> = .init(value: [])
    
    init(populars: [Product]) {
        self.populars.accept(populars)
    }
    
    func viewModelForItem(popularProduct: Product) -> PopularCollectionViewCellViewModel {
        return PopularCollectionViewCellViewModel(popular: popularProduct)
    }
}
