//
//  OneCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import RxSwift
import RxCocoa

final class OneCellViewModel {
    let dataRelay: BehaviorRelay<[Name]> = .init(value: [])
    let dataRelay2: BehaviorRelay<[MultipleCell]> = .init(value: [])

    init() {
        setUpData()
    }
    
    func setUpData() {
        dataRelay.accept(names)
        dataRelay2.accept(multiple)
    }
}
