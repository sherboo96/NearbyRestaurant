//
//  DummeyData.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 03/10/2021.
//

import Foundation

protocol DummeyDataProtocal {
    func getUsers(callback: @escaping (Result<[DummeyPlaces]?, NSError>) -> Void)
}

class DummeyDataAPI: BaseAPI<UsersNetwork>, DummeyDataProtocal {
    func getUsers(callback: @escaping (Result<[DummeyPlaces]?, NSError>) -> Void) {
        var data = [DummeyPlaces]()
        data.append(contentsOf: [
            DummeyPlaces(name: "Grand Kadri Hotel By Cristal Lebanon", lat: 33.85148430277257, long: 35.895525763213946),
            DummeyPlaces(name: "Germanos - Pastry", lat: 33.85334017189446, long: 35.89438946093824),
            DummeyPlaces(name: "Z Burger House", lat: 33.85454300475094, long: 35.894561122304474),
            DummeyPlaces(name: "Collège Oriental", lat: 33.85129821373707, long: 35.89446263654391),
            DummeyPlaces(name: "VERO MODA", lat: 33.85048738635312, long: 35.89664059012788),
        ])
        data.isEmpty ? callback(.failure(NSError())) : callback(.success(data))
        
    }
}
