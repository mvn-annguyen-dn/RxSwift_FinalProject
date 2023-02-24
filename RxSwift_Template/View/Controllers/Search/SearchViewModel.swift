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
    var searching: Bool = false
    var scopeButtonPress: Bool = false
    
    init() {
        self.products.accept([.init(id: 1,
                                    name: "ABC",
                                    imageProduct: "https://i.pinimg.com/564x/60/8a/c1/608ac10592eda8a39e84f0e07040d631.jpg",
                                    discount: 0,
                                    content: "HAHAHAHAH",
                                    price: 50,
                                    isFavorite: false),
                              .init(id: 2, name: "DEF",
                                    imageProduct: "https://i.pinimg.com/564x/60/8a/c1/608ac10592eda8a39e84f0e07040d631.jpg",
                                    discount: 0,
                                    content: "HAHAHAHAH",
                                    price: 20,
                                    isFavorite: false)])
    }

    // MARK: Function
    func numberOfItems(in section: Int) -> Int {
        if searching || scopeButtonPress {
            return searchProducts.value.count
        } else {
            return 0
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> SearchCellViewModel {
        if searching || scopeButtonPress {
            return SearchCellViewModel(product: searchProducts.value[indexPath.row])
        } else {
            return SearchCellViewModel(product: products.value[indexPath.row])
        }
    }
}
