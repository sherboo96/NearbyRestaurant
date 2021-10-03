//
//  RoutesNetwork.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import Foundation
import CoreLocation

protocol RoutesNetworkProtocal {
    func getUsers(coordinatePlaceOne: CLLocationCoordinate2D, coordinatePlaceTwo: CLLocationCoordinate2D, callback: @escaping (Result<Route?, NSError>) -> Void)
}

class RoutesNetworkAPI: BaseAPI<UsersNetwork>, RoutesNetworkProtocal {
    func getUsers(coordinatePlaceOne: CLLocationCoordinate2D, coordinatePlaceTwo: CLLocationCoordinate2D, callback: @escaping (Result<Route?, NSError>) -> Void) {
        self.sendRequest(target: .getDirectionBTW2Places(coordinatePlaceOne: coordinatePlaceOne, coordinatePlaceTwo: coordinatePlaceTwo), responseClass: Route.self, callBack: callback)
    }
}
