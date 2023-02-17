//
//  SliderCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 06/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class SliderCellViewModel {

    var shops: BehaviorRelay<[Shop]> = .init(value: [])
    
    init(shops: [Shop]) {
        self.shops.accept(shops)
    }
    
    func viewModelForItem(sliderShop: Shop) -> SlideCollectionViewCellViewModel {
        return SlideCollectionViewCellViewModel(shop: sliderShop)
    }
}
