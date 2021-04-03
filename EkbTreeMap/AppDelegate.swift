//
//  AppDelegate.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.03.2021.
//

import UIKit
import GoogleMaps
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupCredentials()
        
        window = UIWindow()
        let tabBar = UITabBarController()
        tabBar.setViewControllers([MapViewController()], animated: false)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        return true
    }
    
    
    // MARK: Private
    
    private func setupCredentials() {
        let parser = ApiKeyParser()
        let service = ApiKeyService(parser: parser)
        let key = service.getKey()
        YMKMapKit.setApiKey(key)
    }
}

