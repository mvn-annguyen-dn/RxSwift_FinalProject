//
//  TitleCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 04/01/2023.
//

import RxCocoa

final class TitleCellViewModel {
    var cardRelay: BehaviorRelay<BackCard> = .init(value: BackCard(name: "", title: ""))

    init(card: BackCard) {
        cardRelay.accept(card)
    }
}
