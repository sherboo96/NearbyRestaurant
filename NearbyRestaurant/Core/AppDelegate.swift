//
//  AppDelegate.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import UIKit
import GoogleMaps
import GoogleMobileAds

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
        self.ss()
    }
    
    private func setupRootView() {
        window = UIWindow()
        window?.rootViewController = MapVC()
        window?.makeKeyAndVisible()
    }
    
    private func setupGoogleKey() {
        GMSServices.provideAPIKey(GOOGLEMAPKEY)
    }
    
    private func ss() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}

