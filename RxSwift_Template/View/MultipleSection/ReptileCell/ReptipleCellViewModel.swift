//
//  ReptipleCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import RxSwift
import RxCocoa

final class ReptipleCellViewModel {
    var cardRelay: BehaviorRelay<FrontCard> = .init(value: FrontCard(image: ""))

    init(card: FrontCard) {
        cardRelay.accept(card)
    }
}
