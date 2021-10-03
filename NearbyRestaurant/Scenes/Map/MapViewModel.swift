//
//  MapViewModel.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import Foundation
import GoogleMaps
import RxCoreLocation
import RxSwift
import RxCocoa

class MapViewModel {
    
    private let api: UserNetworkProtocal = UsersAPI()
    private let routeApi: RoutesNetworkProtocal = RoutesNetworkAPI()
    private let dummyPlacesApi: DummeyDataProtocal = DummeyDataAPI()
    private let radius: Double = 1000
    
    var locationManager: CLLocationManager = {
        return CLLocationManager()
    }()
   
    var arrRestaurents: PublishSubject<GooglePlacesResponse> = .init()
    var routeToDraw: PublishSubject<Route> = .init()
    var dummyDataPlaces: BehaviorRelay<[DummeyPlaces]> = .init(value: [])
    var searchData: BehaviorRelay<[DummeyPlaces]> = .init(value: [])
    var getDummyDataPlaces: PublishSubject<[DummeyPlaces]> = .init()
    var selectedPlace: PublishSubject<DummeyPlaces> = .init()
    
    
    func viewDidLoad() {
        self.getDummyPlaceAPI()
    }
    
    func getNearbyRestaurentEndpoint() {
        let coordinate = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        self.api.getUsers(coordinate: coordinate, radius: radius) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let reponse):
                let places = reponse
                self.arrRestaurents.onNext(places ?? GooglePlacesResponse(results: []))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getRouteFor2Places(coordinatesPlaceTwo: CLLocationCoordinate2D) {
        let coordinate = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        self.routeApi.getUsers(coordinatePlaceOne: coordinate, coordinatePlaceTwo: coordinate) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let reponse):
                guard let route = reponse else { return }
                self.routeToDraw.onNext(route)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getDummyPlaceAPI() {
        self.dummyPlacesApi.getUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let reponse):
                let places = reponse
                self.dummyDataPlaces.accept(places ?? [])
                self.getDummyDataPlaces.onNext(places ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didSelectDummyPlace(indexPath: IndexPath) {
        let place = searchData.value[indexPath.row]
        self.selectedPlace.onNext(place)
    }
}
