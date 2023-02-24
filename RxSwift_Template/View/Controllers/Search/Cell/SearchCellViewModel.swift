//
//  SearchCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 07/02/2023.
//

import RxSwift
import RxCocoa

final class SearchCellViewModel {
    private(set) var productBehaviorRelay: BehaviorRelay<Product?> = .init(value: Product())

    init(product: Product?) {
        self.productBehaviorRelay.accept(product)
    }
}
