//
//  WebServices.swift
//  LBSAR
//
//  Created by ajt on 2021/12/16.
//

import Foundation
import CoreLocation

struct WebServices {
    
    static func loadNearbyPointOfInterest(location: CLLocation, radius: Int = 9000, searchKey: String = "", completion: @escaping ([Results]?) -> ()) {
        let router = Router.loadPointOfInterest(location: location, radius: 9000, searchKey: searchKey)
        NetworkRequest.request(router){ (result: Result<PointofInterest, Error>) in
            switch result {
            case .success(let pointofInterest):
                completion(pointofInterest.results)
            case .failure:
                completion(nil)
            }
        }
    }
    
    static func loadDetailInformationFor(_ place: Place, completion: @escaping (PlaceInfo?) -> ()) {
        let router = Router.loadDetailInformation(place: place)
                
        NetworkRequest.request(router){ (result: Result<DirectionDetail, Error>) in
            switch result {
            case .success(let directionDetail):
                completion(directionDetail.result)
            case .failure:
                completion(nil)
            }
        }
    }
}
