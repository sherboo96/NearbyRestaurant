//
//  MapVC.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import UIKit
import GoogleMaps
import RxCoreLocation
import RxSwift
import GoogleMobileAds

class MapVC: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tfSearch: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!
    var bannerView: GADBannerView!
    
    // MARK: - Variable
    private var _mapView: GMSMapView?
    private let disposeBag = DisposeBag()
    let viewModel = MapViewModel()
    let zoomDim:Float = 20.0
    
    init() {
        super.init(nibName: "MapVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nearbyRestaurentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Near By Restaurent", for: .normal)
        return button
    }()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Helper Functions
    func setup() {
        self.setupMap()
        self.setupViewUI()
        self.setupAds()
    }
    
    func setupMap() {
        self.initializeTheLocationManager()
        self.bind()
        self.setupUI()
        self.didChangeAuthorization()
        self.didUpdateLocation()
    }
    
    //MARK: - IBAction
    @objc
    func getNearByRestaurent() {
        self.viewModel.getNearbyRestaurentEndpoint()
    }
}

extension MapVC {
    //MARK: - Map Configureation
    private func initializeTheLocationManager() {
        viewModel.locationManager.requestWhenInUseAuthorization()
        viewModel.locationManager.startUpdatingLocation()
        viewModel.locationManager.distanceFilter = 100
    }
    
    private func setupUI() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: zoomDim)
        _mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        _mapView?.isMyLocationEnabled = true
        view = _mapView
    }
    
    private func didUpdateLocation() {
        viewModel.locationManager.rx
            .didUpdateLocations
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let location = $0.locations.last else { return }
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: self.zoomDim)
                self._mapView?.animate(to: camera)
                //                self.viewModel.locationManager.stopUpdatingLocation()
            })
            .disposed(by: disposeBag)
    }
    
    private func didChangeAuthorization() {
        viewModel.locationManager.rx
            .didChangeAuthorization
            .subscribe(onNext: { [weak self] _, status in
                switch status {
                case .denied:
                    print("Authorization denied")
                case .notDetermined:
                    print("Authorization: not determined")
                case .restricted:
                    print("Authorization: restricted")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("All good fire request")
                    self?.viewModel.locationManager.startUpdatingLocation()
                    self?._mapView?.isMyLocationEnabled = true
                @unknown default:
                    fatalError()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MapVC {
    
    //MARK: -
    func setupViewUI() {
        self.addNearbyRestaurentButton()
    }
    
    func bind() {
        self.placesTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.viewModel.getDummyDataPlaces.asObservable().bind(to: self.placesTableView.rx.items(cellIdentifier: String(describing: PlaceCell.self), cellType: PlaceCell.self)) { index, model, cell in
            cell.setupName(name: model.name)
        }.disposed(by: disposeBag)
        
        self.viewModel.arrRestaurents.subscribe { [weak self] places in
            guard let self = self, let places = places.element else { return }
            let restaurant = places.results
            restaurant.forEach {
                print($0.name)
                let marker = PlaceMarker(place: $0)
                marker.map = self._mapView
            }
        }.disposed(by: disposeBag)
        self.viewModel.routeToDraw.subscribe { [weak self] route in
            guard let self = self, let route = route.element else { return }
            DispatchQueue.main.async(execute: {
                self.drawPath(with: route.routes?.first?.overview_polyline?.points ?? "")
            })
        }.disposed(by: disposeBag)
        
        self.placesTableView.rx.itemSelected.subscribe { indexPath in
            self.viewModel.didSelectDummyPlace(indexPath: indexPath)
        }.disposed(by: disposeBag)
        
        self.viewModel.selectedPlace.subscribe { [weak self] place in
            guard let self = self, let place = place.element else { return }
            self.viewModel.getRouteFor2Places(coordinatesPlaceTwo: CLLocationCoordinate2D(latitude: place.lat, longitude: place.long))
        }.disposed(by: disposeBag)
    }
    
    func addNearbyRestaurentButton() {
        guard let _mapView = _mapView else { return }
        _mapView.addSubview(nearbyRestaurentButton)
        nearbyRestaurentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nearbyRestaurentButton.topAnchor.constraint(equalTo: _mapView.topAnchor, constant: 70),
            nearbyRestaurentButton.trailingAnchor.constraint(equalTo: _mapView.trailingAnchor, constant: -20)
        ])
        self.nearbyRestaurentButton.addTarget(self, action: #selector(getNearByRestaurent), for: .touchUpInside)
    }
    
    private func drawPath(with points : String){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = .red
            polyline.map = self._mapView
        }
    }
}

extension MapVC {
    func setupAds() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        guard let _mapView = _mapView else { return }
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        _mapView.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: _mapView.topAnchor, constant: 100),
            bannerView.trailingAnchor.constraint(equalTo: _mapView.trailingAnchor, constant: -20),
            bannerView.leadingAnchor.constraint(equalTo: _mapView.leadingAnchor, constant: 20),
            bannerView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
