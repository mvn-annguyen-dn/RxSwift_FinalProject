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
        
    func fetchData() {
        let sections: [HomeSectionModel] = [
            
            .sectionSlider(items: [
                .slider(shop: [
                    Shop(nameShop: "Phong shop 1", imageShop: "logo"),
                    Shop(nameShop: "Phong shop 2", imageShop: "logo"),
                    Shop(nameShop: "Phong shop 3", imageShop: "logo")])]),
            
                .sectionRecommend(items: [
                    .recommend(recommendProducts: [
                        Product(name: "recommend 1", imageProduct: "logo", content: "content 1", category: Category(nameCategory: "Test string 1")),
                        Product(name: "recommend 2", imageProduct: "logo", content: "content 2", category: Category(nameCategory: "Test string 2")),
                        Product(name: "recommend 3", imageProduct: "logo", content: "content 3", category: Category(nameCategory: "Test string 3"))])]),
            
                .sectionPopular(items: [
                    .popular(popularProducts: [
                        Product(name: "populor 1", imageProduct: "logo", content: "type 1", category: Category(nameCategory: "demo 1")),
                        Product(name: "populor 2", imageProduct: "logo", content: "type 2", category: Category(nameCategory: "demo 2")),
                        Product(name: "populor 3", imageProduct: "logo", content: "type 3", category: Category(nameCategory: "demo 3"))]),
                ])
        ]
        
        sectionModels.accept(sections)
    }
}
