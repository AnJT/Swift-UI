//
//  Results.swift
//
//  Created by skj on 16.6.2020
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Results: Codable {

  enum CodingKeys: String, CodingKey {
    case icon
    case id
    case openingHours = "opening_hours"
    case types
    case userRatingsTotal = "user_ratings_total"
    case plusCode = "plus_code"
    case reference
    case vicinity
    case scope
    case placeId = "place_id"
    case photos
    case name
    case rating
    case geometry
    case businessStatus = "business_status"
  }

  // the URL of a suggested icon
  var icon: String?
  var id: String?
  var openingHours: OpeningHours?
  // contains an array of feature types describing the given result.
  var types: [String]?
  // the total number of reviews
  var userRatingsTotal: Int?
  var plusCode: PlusCode?
  // deprecated
  var reference: String?
  // a simplified address for the place
  var vicinity: String?
  // deprecated.
  var scope: String?
  // a textual identifier that uniquely identifies a place.
  var placeId: String?
  var photos: [Photos]?
  // human-readable name
  var name: String?
  // contains the place's rating, from 1.0 to 5.0, based on aggregated user reviews.
  var rating: Float?
  var geometry: Geometry?
  var businessStatus: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    icon = try container.decodeIfPresent(String.self, forKey: .icon)
    id = try container.decodeIfPresent(String.self, forKey: .id)
    openingHours = try container.decodeIfPresent(OpeningHours.self, forKey: .openingHours)
    types = try container.decodeIfPresent([String].self, forKey: .types)
    userRatingsTotal = try container.decodeIfPresent(Int.self, forKey: .userRatingsTotal) ?? 0
    plusCode = try container.decodeIfPresent(PlusCode.self, forKey: .plusCode)
    reference = try container.decodeIfPresent(String.self, forKey: .reference) ?? ""
    vicinity = try container.decodeIfPresent(String.self, forKey: .vicinity) ?? ""
    scope = try container.decodeIfPresent(String.self, forKey: .scope)
    placeId = try container.decodeIfPresent(String.self, forKey: .placeId)
    photos = try container.decodeIfPresent([Photos].self, forKey: .photos)
    name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    rating = try container.decodeIfPresent(Float.self, forKey: .rating) ?? 0.0
    geometry = try container.decodeIfPresent(Geometry.self, forKey: .geometry)
    businessStatus = try container.decodeIfPresent(String.self, forKey: .businessStatus)
  }

}
