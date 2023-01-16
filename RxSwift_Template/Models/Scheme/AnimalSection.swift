//
//  OneSectionViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 05/01/2023.
//

import RxSwift
import RxDataSources

struct MusicSection {
    var header: String
    var items: [Item]
}

extension MusicSection: SectionModelType {
    typealias Item = Music

    init(original: MusicSection, items: [Item]) {
        self = original
        self.items = items
    }
}
