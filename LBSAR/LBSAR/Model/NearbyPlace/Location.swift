//
//  Location.swift
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct Location: Codable {

  enum CodingKeys: String, CodingKey {
    case lng
    case lat
  }

  var lng: Float?
  var lat: Float?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    lng = try container.decodeIfPresent(Float.self, forKey: .lng)
    lat = try container.decodeIfPresent(Float.self, forKey: .lat)
  }
}
