//
//  Token.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import Foundation

struct LoginRespone: Codable {
    var success: Bool
    var data: Token?
    var message: String

    enum CodingKeys: String, CodingKey {
        case success, data, message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.data = try container.decodeIfPresent(Token.self, forKey: .data)
        self.message = try container.decode(String.self, forKey: .message)
    }
}

struct Token: Codable {
    var accessToken: String
    var tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
    }
}
