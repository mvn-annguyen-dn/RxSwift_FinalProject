//
//  Cart.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import Foundation

class MessageResponse: Codable {

    var success: Bool
    var data: String?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case success, data, message
    }

    init(success: Bool, data: String? = nil, message: String? = nil) {
        self.success = success
        self.data = data
        self.message = message
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.data = try container.decodeIfPresent(String.self, forKey: .data)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}

class CartResponse: Codable {
    var data: [Cart]?

    enum CodingKeys: String, CodingKey {
        case data
    }

    init(data: [Cart]? = nil) {
        self.data = data
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([Cart].self, forKey: .data)
    }
}

class Cart: Codable {

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

    required init(from decoder: Decoder) throws {
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
