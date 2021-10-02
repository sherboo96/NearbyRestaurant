//
//  AppDelegate.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setup()
        return true
    }
    
    func setup() {
        self.setupGoogleKey()
        self.setupRootView()
    }
    
    private func setupRootView() {
        window = UIWindow()
        window?.rootViewController = MapVC()
        window?.makeKeyAndVisible()
    }
    
    private func setupGoogleKey() {
        GMSServices.provideAPIKey(GOOGLEMAPKEY)
    }
}

