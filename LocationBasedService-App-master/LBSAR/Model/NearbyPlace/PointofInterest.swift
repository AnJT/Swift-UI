//
//  BaseClass.swift
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct PointofInterest: Codable {

  enum CodingKeys: String, CodingKey {
    case results
  }

  var results: [Results]?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    results = try container.decodeIfPresent([Results].self, forKey: .results)
  }

}
