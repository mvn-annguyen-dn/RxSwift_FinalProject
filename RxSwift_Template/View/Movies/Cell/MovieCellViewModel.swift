//
//  MovieCellViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieCellViewModel {
    var movieSub: BehaviorRelay<Movie?> = .init(value: nil)

    init(movie: Movie) {
        movieSub.accept(movie)
    }
}
