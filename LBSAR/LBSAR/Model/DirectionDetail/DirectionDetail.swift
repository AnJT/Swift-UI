//
//  BaseClass.swift
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct DirectionDetail: Codable {

  enum CodingKeys: String, CodingKey {
    case result
  }

  var result: PlaceInfo?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    result = try container.decodeIfPresent(PlaceInfo.self, forKey: .result)
  }
}
