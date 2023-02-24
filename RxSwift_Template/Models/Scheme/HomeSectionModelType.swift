//
//  HomeSectionModelType.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import RxSwift
import RxDataSources

struct HomeSectionModelType {
    var items: [HomeSectionModelItem]
}

enum HomeSectionModelItem {
    case slider(shop: [Shop])
    case recommend(recommendProducts: [Product])
    case popular(popularProducts: [Product])
}

extension HomeSectionModelType: SectionModelType {

    init(original: HomeSectionModelType, items: [HomeSectionModelItem]) {
        self = original
        self.items = items
    }
    
}
