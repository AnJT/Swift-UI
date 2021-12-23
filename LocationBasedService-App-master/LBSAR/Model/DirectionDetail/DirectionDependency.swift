//
//  DirectionDependency.swift
//  LBSAR
//
//  Created by ajt on 2021/12/16.
//

import Foundation
import CoreLocation

struct DirectionDependency {
    let home: HomeItem?
    let currentLocation: CLLocation?
    let place: Results?
}
