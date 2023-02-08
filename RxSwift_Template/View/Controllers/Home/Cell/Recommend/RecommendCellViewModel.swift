//
//  RecommendCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 08/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class RecommendCellViewModel {
    
    var recommendBehaviorRelay: BehaviorRelay<[HomeSectionModel]> = .init(value: [])

    let recommendSections: [HomeSectionModel] = [.sectionRecommend(items: [.recommend]), .sectionRecommend(items: [.recommend]), .sectionRecommend(items: [.recommend])]
    
    func fetchData() {
        recommendBehaviorRelay.accept(recommendSections)
    }
}
