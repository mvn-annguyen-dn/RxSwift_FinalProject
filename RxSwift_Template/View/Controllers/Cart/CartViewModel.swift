//
//  CartViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import RxSwift
import RxCocoa

final class CartViewModel {
    
    private var bag: DisposeBag = DisposeBag()
    var carts: BehaviorRelay<[Cart]> = .init(value: [])
    var errorBehaviorRelay: PublishRelay<ApiError> = .init()
    var loadingCart: BehaviorRelay<Bool> = .init(value: false)
    
    func getApiCart() {
        ApiNetWorkManager.shared.request(CartResponse.self, .target(MainTarget.cart))
            .subscribe { response in
                switch response {
                case .success(let carts):
                    self.carts.accept(carts.data ?? [])
                    self.loadingCart.accept(true)
                case .failure(let error):
                    self.errorBehaviorRelay.accept(error as? ApiError ?? .invalidResponse)
                    self.loadingCart.accept(false)
                }
            }
            .disposed(by: bag)
    }
    
    func requestUpdateCart(orderId: Int, quantity: Int) -> Single<MessageResponse> {
        return ApiNetWorkManager.shared.request(MessageResponse.self, .target(MainTarget.updateCart(id: orderId, quantity: quantity)))
    }
    
    func requestDeleteCart(orderId: Int) -> Single<MessageResponse> {
       return ApiNetWorkManager.shared.request(MessageResponse.self, .target(MainTarget.deleteCart(id: orderId)))
    }
    
    func viewModelForItem(index: Int) -> CartCellViewModel {
        return CartCellViewModel(cart: carts.value[safe: index])
    }
    
    func totalPriceCarts() -> BehaviorRelay<Int> {
        let total: BehaviorRelay<Int> = .init(value: 0)
        for cart in carts.value {
            total.accept(total.value + (cart.quantity ?? 0) * (cart.price ?? 0))
        }
        return total
    }
}
