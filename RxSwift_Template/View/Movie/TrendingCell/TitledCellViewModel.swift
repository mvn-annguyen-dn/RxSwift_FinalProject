//
//  TrendingCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 06/01/2023.
//

import RxSwift
import RxCocoa

final class TitledCellViewModel {
    var trendingItem: BehaviorRelay<Movie?> = .init(value: nil)

    init(movie: Movie) {
        trendingItem.accept(movie)
    }
}
