//
//  ProductCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 17/01/2023.
//

import RxSwift

final class ProductCellViewModel {

    private(set) var productSubject: BehaviorSubject<Product?> = .init(value: Product())

    init(product: Product?) {
        self.productSubject.onNext(product)
    }
}
