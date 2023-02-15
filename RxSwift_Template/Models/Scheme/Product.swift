//
//  Product.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 08/02/2023.
//

import Foundation

final class ProductResponse: Codable {
    
    var data: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([Product].self, forKey: .data)
    }
}

final class ShopResponse: Codable {
    
    var data: [Shop]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([Shop].self, forKey: .data)
    }
}

final class Product: Codable {
    
    var id: Int?
    var name: String?
    var imageProduct: String?
    var discount: Int?
    var content: String?
    var price: Int?
    var category: Category?
    var images: [ImageProduct]?
    var isFavorite: Bool = false
    
    init(name: String? = nil, imageProduct: String? = nil, category: Category? = nil) {
        self.name = name
        self.imageProduct = imageProduct
        self.category = category
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, discount, content, price, category
        case imageProduct = "image_product"
        case images = "image_p_r"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.discount = try container.decode(Int.self, forKey: .discount)
        self.content = try container.decode(String.self, forKey: .content)
        self.price = try container.decode(Int.self, forKey: .price)
        self.category = try container.decode(Category.self, forKey: .category)
        self.images = try container.decode([ImageProduct].self, forKey: .images)
        self.imageProduct = try container.decode(String.self, forKey: .imageProduct)
    }
}

final class Category: Codable {
    
    var id: Int?
    var nameCategory: String?
    var shop: Shop?
    
    init(shop: Shop? = nil) {
        self.shop = shop
    }
    
    enum CodingKeys: String, CodingKey {
        case id, shop
        case nameCategory = "name_category"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.shop = try container.decode(Shop.self, forKey: .shop)
        self.nameCategory = try container.decode(String.self, forKey: .nameCategory)
    }
}

final class Shop: Codable {
    
    var id: Int?
    var nameShop: String?
    var address: String?
    var phoneNumber: String?
    var emailShop: String?
    var imageShop: String?
    var shopDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, address
        case nameShop = "name_shop"
        case phoneNumber = "phone_number"
        case emailShop = "email_shop"
        case imageShop = "image_shop"
        case shopDescription = "description"
    }
    
    init(nameShop: String? = nil) {
        self.nameShop = nameShop
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.address = try container.decode(String.self, forKey: .address)
        self.nameShop = try container.decode(String.self, forKey: .nameShop)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.emailShop = try container.decode(String.self, forKey: .emailShop)
        self.imageShop = try container.decode(String.self, forKey: .imageShop)
        self.shopDescription = try container.decode(String.self, forKey: .shopDescription)
    }
}

final class ImageProduct: Codable {
    
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case image
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decode(String.self, forKey: .image)
    }
}
