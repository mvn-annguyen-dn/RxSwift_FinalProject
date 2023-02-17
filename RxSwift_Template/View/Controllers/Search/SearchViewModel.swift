//
//  SearchViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 07/02/2023.
//

import RxSwift
import RxCocoa

final class SearchViewModel {
    
    // MARK: Properties
    private(set) var products: BehaviorRelay<[Product]> = .init(value: [])
    var searchProducts: BehaviorRelay<[Product]> = .init(value: [])
    var searching: BehaviorRelay<Bool> = .init(value: false)
    var scopeButtonPress: BehaviorRelay<Bool> = .init(value: false)
    var errorStatus: PublishRelay<ApiError?> = .init()
    private let bagModel: DisposeBag = DisposeBag()

    // MARK: Function
    func numberOfItems(in section: Int) -> Int {
        if searching.value || scopeButtonPress.value {
            return searchProducts.value.count
        } else {
            return 0
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> SearchCellViewModel {
        if searching.value || scopeButtonPress.value {
            return SearchCellViewModel(product: searchProducts.value[indexPath.row])
        } else {
            return SearchCellViewModel(product: products.value[indexPath.row])
        }
    }
}

extension SearchViewModel {
    func requestSearchApi() {
        ApiNetWorkManager.shared.request(ProductResponse.self, .target(MainTarget.search))
            .subscribe(onSuccess: { [weak self] response in
                guard let this = self else { return }
                this.products.accept(Array(response.data))
            }, onFailure: { error in
                self.errorStatus.accept(error as? ApiError ?? .unknown)
            })
            .disposed(by: bagModel)
    }
}
