//
//  CarouselCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 17/01/2023.
//

import RxCocoa
import RxSwift

final class CarouselCellViewModel {
    private(set) var imageSubject: BehaviorSubject<String?> = .init(value: "")

    init(data: String?) {
        self.imageSubject.onNext(data)
    }
}
