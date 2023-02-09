//
//  HomeSectionModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import RxSwift
import RxDataSources

enum HomeSectionModel {
    case sectionSlider(items: [Item])
    case sectionRecommend(items: [Item])
    case sectionPopular(items: [Item])
}

enum HomeSectionItem {
    case slider(shop: [Shop])
    case recommend(recommendProducts: [Product])
    case popular(popularProducts: [Product])
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeSectionItem

    var items: [HomeSectionItem] {
        switch self {
        case .sectionSlider(items: let items):
            return items.map { $0 }
        case .sectionRecommend(items: let items):
            return items.map { $0 }
        case .sectionPopular(items: let items):
            return items.map { $0 }
        }
    }

    init(original: HomeSectionModel, items: [Item]) {
        switch original {
        case .sectionSlider(items: _):
            self = .sectionSlider(items: items)
        case .sectionRecommend(items: _):
            self = .sectionRecommend(items: items)
        case .sectionPopular(items: let items):
            self = .sectionPopular(items: items)
        }
    }
}
