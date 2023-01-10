//
//  UpcomingCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 09/01/2023.
//

import RxCocoa
import RxSwift

final class NonTitleCellViewModel {
    var upcomingItem: BehaviorRelay<Movie?> = .init(value: nil)

    init(movie: Movie) {
        upcomingItem.accept(movie)
    }
}
