//
//  PlaceNetwork.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import Foundation
import Alamofire
import CoreLocation

enum UsersNetwork {
    case getNearByRestaurent(coordinate: CLLocationCoordinate2D, radius: Double)
    case getDirectionBTW2Places(coordinatePlaceOne: CLLocationCoordinate2D, coordinatePlaceTwo: CLLocationCoordinate2D)
}

extension UsersNetwork: TargetType {
    var baseURL: String {
        switch self {
        default:
            return "https://maps.googleapis.com/maps/api"
        }
    }
    
    var path: String {
        switch self {
        case .getNearByRestaurent(let coordinate, let radius):
            return "/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&key=\(GOOGLEPLACEKEY)&types=food"
        case .getDirectionBTW2Places(let coordinatePlaceOne, let coordinatePlaceTwo):
            return "/directions/json?origin=\(coordinatePlaceOne.latitude),\(coordinatePlaceOne.longitude)&destination=\(coordinatePlaceTwo.latitude),\(coordinatePlaceTwo.longitude)&sensor=false&mode=walking&key=\(GOOGLEPLACEKEY)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNearByRestaurent:
            return .get
        case .getDirectionBTW2Places:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getNearByRestaurent:
            return .requestPlain
        case .getDirectionBTW2Places:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
