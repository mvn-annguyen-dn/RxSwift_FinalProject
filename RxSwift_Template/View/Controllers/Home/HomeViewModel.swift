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
    var sectionModels: BehaviorRelay<[HomeSectionModelType]> = .init(value: [])

    func fetchData() {
        let sections: [HomeSectionModelType] = [
            .init(items: [.slider(shop: [Shop(nameShop: "Phong shop 1", imageShop: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg"),
                                         Shop(nameShop: "Phong shop 2", imageShop: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg"),
                                         Shop(nameShop: "Phong shop 3", imageShop: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg")]),
                          .recommend(recommendProducts: [
                            Product(name: "recommend 1", imageProduct: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg", content: "content 1", category: Category(nameCategory: "Test string 1")),
                            Product(name: "recommend 2", imageProduct: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg", content: "content 2", category: Category(nameCategory: "Test string 2")),
                            Product(name: "recommend 3", imageProduct: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg", content: "content 3", category: Category(nameCategory: "Test string 3"))]
                                    ),
                          .popular(popularProducts: [
                            Product(name: "recommend 1", imageProduct: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg", content: "content 1", category: Category(nameCategory: "Test string 1")),
                            Product(name: "recommend 2", imageProduct: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg", content: "content 2", category: Category(nameCategory: "Test string 2")),
                            Product(name: "recommend 3", imageProduct: "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg", content: "content 3", category: Category(nameCategory: "Test string 3"))
                          ])
            ])
        ]
        sectionModels.accept(sections)
    }
}
