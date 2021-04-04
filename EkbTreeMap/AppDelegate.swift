//
//  AppDelegate.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.03.2021.
//

import UIKit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupCredentials()
        
        window = UIWindow()
        let tabBar = UITabBarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        mainCoordinator = MainCoordinator(rootController: tabBar)
        mainCoordinator?.start(animated: false)
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

