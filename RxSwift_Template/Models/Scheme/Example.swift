//
//  Example.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 02/02/2023.
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

struct Music: Decodable {
     var artistName: String?
     var id: String?
     var name: String?
     var releaseDate: String?
     var copyright: String?
     var artworkUrl100: String?

     init(artistName: String? = nil, id: String? = nil, name: String? = nil, releaseDate: String? = nil, copyright: String? = nil, artworkUrl100: String? = nil) {
         self.artistName = artistName
         self.id = id
         self.name = name
         self.releaseDate = releaseDate
         self.copyright = copyright
         self.artworkUrl100 = artworkUrl100
     }

     enum CodingKeys: String, CodingKey {
         case artistName, id, name, releaseDate, copyright, artworkUrl100
     }

     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         artistName = try? container.decode(String.self, forKey: .artistName)
         id = try? container.decode(String.self, forKey: .id)
         name = try? container.decode(String.self, forKey: .name)
         releaseDate = try? container.decode(String.self, forKey: .releaseDate)
         copyright = try? container.decode(String.self, forKey: .copyright)
         artworkUrl100 = try? container.decode(String.self, forKey: .artworkUrl100)
     }
 }

 struct FeedResults: Decodable {
     var results: [Music]?

     init(results: [Music]?) {
         self.results = results
     }

     enum CodingKeys: String, CodingKey {
         case feed, results
     }

     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         let feed = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .feed)
         results = try? feed.decode([Music].self, forKey: .results)
     }
 }
