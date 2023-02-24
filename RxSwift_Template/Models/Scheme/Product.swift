//
//  Product.swift
//  RxSwift_Template
//

//  Created by Luong Tran M. VN.Danang on 10/02/2023.
//

import RxSwift
import RealmSwift

// MARK: Models API
final class ProductResponse: Object, Decodable {

    var data = List<Product>()
    
    enum CodingKeys: String, CodingKey {
        case data
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(List<Product>.self, forKey: .data)
    }
}
    
final class ShopResponse: Object, Decodable {

    var data = List<Shop>()

    enum CodingKeys: String, CodingKey {
        case data
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(List<Shop>.self, forKey: .data)
    }
}
    
final class Product: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var imageProduct: String = ""
    @objc dynamic var discount: Int = 0
    @objc dynamic var content: String = ""
    @objc dynamic var price: Int = 0
    @objc dynamic var category: Category?
    var images = List<ImageProduct>()

    enum CodingKeys: String, CodingKey {
        case id, name, discount, content, price, category
        case imageProduct = "image_product"
        case images = "image_p_r"
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.discount = try container.decode(Int.self, forKey: .discount)
        self.content = try container.decode(String.self, forKey: .content)
        self.price = try container.decode(Int.self, forKey: .price)
        self.category = try container.decode(Category.self, forKey: .category)
        self.images = try container.decode(List<ImageProduct>.self, forKey: .images)
        self.imageProduct = try container.decode(String.self, forKey: .imageProduct)
    }
}

final class Category: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var nameCategory: String = ""
    @objc dynamic var shop: Shop?

    enum CodingKeys: String, CodingKey {
        case id, shop
        case nameCategory = "name_category"
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.shop = try container.decode(Shop.self, forKey: .shop)
        self.nameCategory = try container.decode(String.self, forKey: .nameCategory)
    }
}

final class Shop: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var nameShop: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var emailShop: String = ""
    @objc dynamic var imageShop: String = ""
    @objc dynamic var shopDescription: String = ""

    enum CodingKeys: String, CodingKey {
        case id, address
        case nameShop = "name_shop"
        case phoneNumber = "phone_number"
        case emailShop = "email_shop"
        case imageShop = "image_shop"
        case shopDescription = "description"
    }

    convenience init(from decoder: Decoder) throws {
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

final class ImageProduct: Object, Decodable {
    
    @objc dynamic var image: String = ""
    
    enum CodingKeys: String, CodingKey {
        case image
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decode(String.self, forKey: .image)
    }
}
