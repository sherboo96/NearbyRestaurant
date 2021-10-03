//
//  NearbyRestaurant.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import Foundation
import CoreLocation

protocol UserNetworkProtocal {
    func getUsers(coordinate: CLLocationCoordinate2D, radius: Double, callback: @escaping (Result<GooglePlacesResponse?, NSError>) -> Void)
}

class UsersAPI: BaseAPI<UsersNetwork>, UserNetworkProtocal {
    func getUsers(coordinate: CLLocationCoordinate2D, radius: Double, callback: @escaping (Result<GooglePlacesResponse?, NSError>) -> Void) {
        self.sendRequest(target: .getNearByRestaurent(coordinate: coordinate, radius: radius), responseClass: GooglePlacesResponse.self, callBack: callback)
    }
}


