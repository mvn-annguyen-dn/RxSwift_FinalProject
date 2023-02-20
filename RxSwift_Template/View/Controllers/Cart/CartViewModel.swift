//
//  CartViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class CartViewModel {
    
    private var bag: DisposeBag = DisposeBag()
    var carts: BehaviorRelay<[Cart]> = .init(value: [Cart(productName: "product name", quantity: 2, price: 3, productImage: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg"), Cart(productName: "product name", quantity: 4, price: 5, productImage: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg")])
    
    func viewModelForItem(index: Int) -> CartCellViewModel {
        return CartCellViewModel(cart: carts.value[index])
    }
    
    func totalPriceCarts() -> BehaviorRelay<Int> {
        let total: BehaviorRelay<Int> = .init(value: 0)
        for cart in carts.value {
            total.accept(total.value + (cart.quantity ?? 0) * (cart.price ?? 0))
        }
        return total
    }
}
