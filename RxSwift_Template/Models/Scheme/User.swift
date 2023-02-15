//
//  User.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 15/02/2023.
//

import Foundation

struct UserResponse: Decodable {
    var data: User?

    enum CodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(User.self, forKey: .data)
    }
}

struct User: Decodable {
    var id: Int?
    var userName: String?
    var email: String?
    var gender: Int?
    var phoneNumber: String?
    var address: String?

    enum CodingKeys: String, CodingKey {
        case id, email, gender, address
        case userName = "user_name"
        case phoneNumber = "phone_number"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    }
}
