//
//  MultipleSectionViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 05/01/2023.
//

import RxSwift
import RxDataSources

enum HomeSectionModel {
    case informationSectionOne(title: String, items: [HomeSectionItem])
    case informationSectionTwo(title: String, items: [HomeSectionItem])
}

enum HomeSectionItem {
    case itemOne(musics: Music)
    case itemTwo(title: String, musics: Music)
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeSectionItem
    
    var items: [HomeSectionItem] {
        switch self {
        case .informationSectionOne(title: _, items: let items):
            return items.map { $0 }
        case .informationSectionTwo(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: HomeSectionModel, items: [HomeSectionItem]) {
        switch original {
        case let .informationSectionOne(title: title, items: _):
            self = .informationSectionOne(title: title, items: items)
        case let .informationSectionTwo(title: title, items: _):
            self = .informationSectionTwo(title: title, items: items)
        }
    }
}

extension HomeSectionModel {
    var title: String {
        switch self {
        case .informationSectionOne(title: let title, items: _):
            return title
        case .informationSectionTwo(title: let title, items: _):
            return title
        }
    }
}
