//
//  Music.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 05/01/2023.
//

import RxDataSources

// Model Api
enum SectionAPI {
    case upcoming
    case trending

    var type: String {
        switch self {
        case .upcoming:
            return "Upcoming"
        case .trending:
            return "Trending"
        }
    }
}

enum SectionItem {
    case nonTilte(item: Movie)
    case titled(item: Movie)
}

struct MySectionModel {
    var header: SectionAPI
    var items: [SectionItem]
}

extension MySectionModel: SectionModelType {
    init(original: MySectionModel, items: [SectionItem]) {
        self = original
        self.items = items
    }
}

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

     init(id: Int?,
          originalTitle: String?,
          overview: String?,
          posterPath: String?,
          title: String?) {
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
