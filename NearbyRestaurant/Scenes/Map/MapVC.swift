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
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var tfSearch: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var _mapView: GMSMapView!
    var bannerView: GADBannerView!
    
    // MARK: - Variable
    //    private var _mapView: GMSMapView?
    private let disposeBag = DisposeBag()
    let viewModel = MapViewModel()
    let zoomDim:Float = 20.0
    
    init() {
        super.init(nibName: "MapVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Helper Functions
    func setup() {
        self.bind()
        self.setupMap()
        self.setupViewUI()
        self.setupAds()
        self.viewModel.viewDidLoad()
        self.setupTXTSearch()
    }
    
    func setupMap() {
        self.initializeTheLocationManager()
        self.setupUI()
        self.didChangeAuthorization()
        self.didUpdateLocation()
    }
    
    //MARK: - IBAction
    @IBAction func getNearByRestaurent(_ sender: UIButton) {
        self.viewModel.getNearbyRestaurentEndpoint()
    }
}

//MARK: - Map Data
extension MapVC {
    //MARK: - Map Configureation
    private func initializeTheLocationManager() {
        viewModel.locationManager.requestWhenInUseAuthorization()
        viewModel.locationManager.startUpdatingLocation()
        viewModel.locationManager.distanceFilter = 100
    }
    
    private func setupUI() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: zoomDim)
        _mapView.animate(to: camera)
        _mapView.isMyLocationEnabled = true
    }
    
    private func didUpdateLocation() {
        viewModel.locationManager.rx
            .didUpdateLocations
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let location = $0.locations.last else { return }
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: self.zoomDim)
                self._mapView.animate(to: camera)
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
                    self?._mapView.isMyLocationEnabled = true
                @unknown default:
                    fatalError()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Data Binding with update UserInterface
extension MapVC {
    
    private func setupViewUI() {
        self.registerTableCell()
        placesTableView.isHidden = true
    }
    
    private func registerTableCell() {
        self.placesTableView.registerCell(cell: PlaceCell.self)
    }
    
    //MARK: - Data Binding
    private func bind() {
        self.placesTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.viewModel.searchData.asObservable().bind(to: self.placesTableView.rx.items(cellIdentifier: String(describing: PlaceCell.self), cellType: PlaceCell.self)) { index, model, cell in
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
        
        self.placesTableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self, let indexPath = indexPath.element else { return }
            self.viewModel.didSelectDummyPlace(indexPath: indexPath)
        }.disposed(by: disposeBag)
        
        self.viewModel.searchData.subscribe { _ in
            self.placesTableView.reloadData()
        }.disposed(by: disposeBag)
        
        self.viewModel.selectedPlace.subscribe { [weak self] place in
            guard let self = self, let place = place.element else { return }
            self.viewModel.getRouteFor2Places(coordinatesPlaceTwo: CLLocationCoordinate2D(latitude: place.lat, longitude: place.long))
        }.disposed(by: disposeBag)
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

//MARK: - Admob unit ids:
extension MapVC {
    private func setupAds() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        guard let _mapView = _mapView else { return }
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        _mapView.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: _mapView.topAnchor, constant: 0),
            bannerView.trailingAnchor.constraint(equalTo: _mapView.trailingAnchor, constant: -20),
            bannerView.leadingAnchor.constraint(equalTo: _mapView.leadingAnchor, constant: 20),
            bannerView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

//MARK: - Search
extension MapVC {
    func setupTXTSearch() {
        tfSearch.rx.text.subscribe(onNext: { text in
            let places = self.viewModel.dummyDataPlaces.value.filter({$0.name.contains(text ?? "")})
            self.placesTableView.isHidden = places.isEmpty ?  true : false
            self.viewModel.searchData.accept(places)
        }).disposed(by: disposeBag)
    }
}
