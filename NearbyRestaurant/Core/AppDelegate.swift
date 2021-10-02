//
//  AppDelegate.swift
//  NearbyRestaurant
//
//  Created by Mahmoud Sherbeny on 02/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupRootView()
        return true
    }
    
    private func setupRootView() {
        window = UIWindow()
        window?.rootViewController = MapVC()
        window?.makeKeyAndVisible()
    }
}

