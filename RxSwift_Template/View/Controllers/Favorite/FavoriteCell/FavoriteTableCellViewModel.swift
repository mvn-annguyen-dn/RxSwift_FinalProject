//
//  FavoriteTableCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 10/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteTableCellViewModel {

    var product: BehaviorRelay<Product?> = .init(value: nil)
    
    init(product: Product?) {
        self.product.accept(product)
    }
}
