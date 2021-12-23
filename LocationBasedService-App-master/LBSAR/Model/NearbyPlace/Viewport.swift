//
//  Viewport.swift
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct Viewport: Codable {

  enum CodingKeys: String, CodingKey {
    case northeast
    case southwest
  }

  var northeast: Northeast?
  var southwest: Southwest?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    northeast = try container.decodeIfPresent(Northeast.self, forKey: .northeast)
    southwest = try container.decodeIfPresent(Southwest.self, forKey: .southwest)
  }

}
