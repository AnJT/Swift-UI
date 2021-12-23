//
//  Geometry.swift
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct Geometry: Codable {

  enum CodingKeys: String, CodingKey {
    case location
    case viewport
  }

  var location: Location?
  var viewport: Viewport?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    location = try container.decodeIfPresent(Location.self, forKey: .location)
    viewport = try container.decodeIfPresent(Viewport.self, forKey: .viewport)
  }

}
