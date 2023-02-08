//
//  PopularCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 08/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class PopularCellViewModel {
    
    var popularBehaviorRelay: BehaviorRelay<[HomeSectionModel]> = .init(value: [])

    let popularSections: [HomeSectionModel] = [.sectionPopular(items: [.popular]), .sectionPopular(items: [.popular]), .sectionPopular(items: [.popular]), .sectionPopular(items: [.popular])]
    
    func fetchData() {
        popularBehaviorRelay.accept(popularSections)
    }
}
