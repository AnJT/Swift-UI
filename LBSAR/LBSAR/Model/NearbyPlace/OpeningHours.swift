//
//  OpeningHours.swift
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct OpeningHours: Codable {

  enum CodingKeys: String, CodingKey {
    case openNow = "open_now"
  }
  
  // a boolean value indicating if the place is open at the current time.
  var openNow: Bool?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    openNow = try container.decodeIfPresent(Bool.self, forKey: .openNow)
  }
}
