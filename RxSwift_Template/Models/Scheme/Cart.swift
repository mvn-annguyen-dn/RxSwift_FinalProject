//
//  Cart.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 14/02/2023.
//

import Foundation

struct MessageResponse: Decodable {

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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.data = try container.decodeIfPresent(String.self, forKey: .data)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
