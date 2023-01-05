//
//  OneSectionViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 05/01/2023.
//

import RxSwift
import RxDataSources

struct AnimalSection {
    var header: String
    var items: [Item]
}

extension AnimalSection: SectionModelType {
    typealias Item = Music

    init(original: AnimalSection, items: [Item]) {
        self = original
        self.items = items
    }
}
