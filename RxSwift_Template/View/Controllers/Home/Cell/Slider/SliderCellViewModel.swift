//
//  SliderCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 06/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class SliderCellViewModel {
    
    var sliderBehaviorRelay: BehaviorRelay<[HomeSectionModel]> = .init(value: [])

    let sliderSections: [HomeSectionModel] = [.sectionSlider(items: [.slider]), .sectionSlider(items: [.slider]), .sectionSlider(items: [.slider])]

    
    func fetchData() {
        sliderBehaviorRelay.accept(sliderSections)
    }
}
