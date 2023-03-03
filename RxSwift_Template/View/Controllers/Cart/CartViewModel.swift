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
    var carts: PublishRelay<[Cart]> = .init()
    var errorBehaviorRelay: PublishRelay<ApiError> = .init()
    
    func getApiCart() {
        ApiNetWorkManager.shared.request(CartResponse.self, .target(MainTarget.cart))
            .subscribe { response in
                switch response {
                case .success(let carts):
                    self.carts.accept(carts.data ?? [])
                case .failure(let error):
                    self.errorBehaviorRelay.accept(error as? ApiError ?? .invalidResponse)
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
    
    func viewModelForItem(cart: Cart) -> CartCellViewModel {
        return CartCellViewModel(cart: cart)
    }
}
