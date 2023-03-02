//
//  Cart.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import Foundation

struct Cart: Codable {

    var id: Int?
    var userId: Int?
    var productId: Int?
    var productName: String?
    var quantity: Int?
    var price: Int?
    var status: Int?
    var productImage: String?

    enum CodingKeys: String, CodingKey {
        case id, quantity, price, status
        case userId = "user_id"
        case productId = "product_id"
        case productName = "product_name"
        case productImage = "image_product"
    }

    init(id: Int? = nil, userId: Int? = nil, productId: Int? = nil, productName: String? = nil, quantity: Int? = nil, price: Int? = nil, status: Int? = nil, productImage: String? = nil) {
        self.id = id
        self.userId = userId
        self.productId = productId
        self.productName = productName
        self.quantity = quantity
        self.price = price
        self.status = status
        self.productImage = productImage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.price = try container.decode(Int.self, forKey: .price)
        self.status = try container.decode(Int.self, forKey: .status)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.productImage = try container.decode(String.self, forKey: .productImage)
    }
}
