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
    var currentIndex: BehaviorRelay<Int> = .init(value: 0)
    
    init(shops: [Shop]) {
        self.shops.accept(shops)
    }
    
    func viewModelForItem(index: Int) -> SlideCollectionViewCellViewModel {
        return SlideCollectionViewCellViewModel(shop: shops.value[safe: index])
    }
    
    func numberOfPage() -> Int {
        return shops.value.count >= Define.numberOfPage ? Define.numberOfPage : shops.value.count
    }
}

extension SliderCellViewModel {
    private struct Define {
        static let numberOfPage: Int = 3
    }
}
