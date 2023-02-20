//
//  CartCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class CartCellViewModel {
    
    var cart: BehaviorRelay<Cart?> = .init(value: nil)
    
    init(cart: Cart) {
        self.cart.accept(cart)
    }
}
