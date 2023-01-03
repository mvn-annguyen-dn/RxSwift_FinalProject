//
//  Movies.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import Foundation

struct MovieResponse: Codable {
    var results: [Movie]?

    enum CodingKeys: CodingKey {
        case results
    }

    init(results: [Movie]? = nil) {
        self.results = results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent([Movie].self, forKey: .results)
    }
}

struct Movie: Codable {
    var id: Int?
    var originalTitle: String?
    var overview: String?
    var posterPath: String?
    var title: String?

    enum CodingKeys: String, CodingKey {
        case id, overview, title
        case originalTitle = "original_title"
        case posterPath = "poster_path"
    }

    init(id: Int? = nil,
         originalTitle: String? = nil,
         overview: String? = nil,
         posterPath: String? = nil,
         title: String? = nil) {
        self.id = id
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.title = title
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
}

struct VideoResponse: Codable {
    var results: [Video]?

    enum CodingKeys: String, CodingKey {
        case results
    }

    init(results: [Video]? = nil) {
        self.results = results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent([Video].self, forKey: .results)
    }
}

struct Video: Codable {
    var key: String?

    enum CodingKeys: String, CodingKey {
        case key
    }

    init(key: String? = nil) {
        self.key = key
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decodeIfPresent(String.self, forKey: .key)
    }
}
