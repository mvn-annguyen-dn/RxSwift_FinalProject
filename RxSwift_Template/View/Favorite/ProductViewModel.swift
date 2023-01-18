//
//  ProductViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 17/01/2023.
//

import RxSwift
import RxCocoa

final class ProductViewModel {

    var productRelay: BehaviorRelay<[Product]> = .init(value: [])
    var isLoading: PublishSubject<Bool> = .init()
    var error: PublishSubject<String> = .init()

    private var bagModel = DisposeBag()

    func getDataProduct() {
        getProductsApi()
            .subscribe { [weak self] res in
                guard let this = self else { return }
                this.isLoading.onNext(true)
                this.productRelay.accept(res.data.toArray())
            } onFailure: { [weak self] err in
                guard let this = self else { return }
                this.isLoading.onNext(true)
                this.error.onNext(err.localizedDescription)
            }
            .disposed(by: bagModel)
    }
}

//MARK: getData From APIs
extension ProductViewModel {

    private func getProductsApi() -> Single<ProductResponse> {
        return ApiNetWorkManager.shared.request(ProductResponse.self, .products)
    }
}

//MARK: transform Data to CellModel
extension ProductViewModel {

    func viewModelForItem(at element: Product) -> ProductCellViewModel {
        return ProductCellViewModel(product: element)
    }

    func viewModelForDetail(at indexPath: IndexPath) -> DetailViewModel {
        return DetailViewModel(product: productRelay.value[indexPath.row])
    }
}
