//
//  HeaderCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 05/01/2023.
//

import RxSwift

final class HeaderCellViewModel {
    var headerOb: BehaviorSubject<String> = .init(value: "")

    init(title: TypeSection) {
        headerOb.onNext(title.type)
    }
}
