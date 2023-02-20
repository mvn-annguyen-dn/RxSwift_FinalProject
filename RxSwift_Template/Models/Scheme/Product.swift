//
//  Product.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 08/02/2023.
//

import Foundation

struct Product {

    var id: Int?
    var name: String?
    var imageProduct: String?
    var discount: Int?
    var content: String?
    var price: Int?
    var category: Category?
    var images: ImageProduct?
    var isFavorite: Bool = false
}

struct Category {

    var id: Int?
    var nameCategory: String?
    var shop: Shop?
}

struct Shop {

    var id: Int?
    var nameShop: String?
    var address: String?
    var phoneNumber: String?
    var emailShop: String?
    var imageShop: String?
    var shopDescription: String?
}

struct ImageProduct {

    var image: String
}
