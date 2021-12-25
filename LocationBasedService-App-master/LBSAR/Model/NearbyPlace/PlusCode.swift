//
//  PlusCode.swift
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct PlusCode: Codable {

  enum CodingKeys: String, CodingKey {
    case globalCode = "global_code"
    case compoundCode = "compound_code"
  }

  var globalCode: String?
  var compoundCode: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    globalCode = try container.decodeIfPresent(String.self, forKey: .globalCode)
    compoundCode = try container.decodeIfPresent(String.self, forKey: .compoundCode)
  }
}
