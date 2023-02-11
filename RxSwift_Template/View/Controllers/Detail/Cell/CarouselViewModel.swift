//
//  CarouselViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 10/02/2023.
//

import RxSwift

final class CarouselCellViewModel {

    private(set) var imageSubject: BehaviorSubject<String?> = .init(value: "")
    
    init(data: String?) {
        self.imageSubject.onNext(data)
    }
}
