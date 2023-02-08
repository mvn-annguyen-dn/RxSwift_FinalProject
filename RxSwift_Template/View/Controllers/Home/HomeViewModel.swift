//
//  HomeViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewModel {
    
    // multiple sections
    var sectionModels: BehaviorRelay<[HomeSectionModel]> = .init(value: [])
    
    let sections: [HomeSectionModel] = [
        .sectionSlider(items: [.slider]),
        .sectionRecommend(items: [.recommend]),
        .sectionPopular(items: [.popular])
    ]
    
    func fetchData() {
        sectionModels.accept(sections)
    }
}
