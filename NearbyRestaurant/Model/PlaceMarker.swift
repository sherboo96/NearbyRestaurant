//
//  PlaceMarker.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import Foundation
import GoogleMaps
import CoreLocation

class PlaceMarker: GMSMarker {
    let place: Place
    
    init(place: Place) {
        self.place = place
        super.init()
        let coordinate = CLLocationCoordinate2D(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude)
        position = coordinate
        icon = UIImage(named: "pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
