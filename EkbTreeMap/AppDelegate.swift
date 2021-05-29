//
//  AppDelegate.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.03.2021.
//

import UIKit
import YandexMapsMobile
import IQKeyboardManagerSwift
import Swinject
import SVProgressHUD


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let container = Container()
    var mainCoordinator: Coordinator?
    
    lazy var assembler: Assembler = {
        return Assembler(container: container)
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupCredentials()
        setupDI()
        setupUI()
        return true
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        window = UIWindow()
        let tabBar = UITabBarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        let resolver = IResolverImpl(resolver: container.synchronize())
        mainCoordinator = MainCoordinator(rootController: tabBar, resolver: resolver)
        mainCoordinator?.start(animated: false)
        IQKeyboardManager.shared.enable = true
        setupProgressHUD()
    }
    
    private func setupDI() {
        assembler.apply(assemblies: [ServiceAssembly(),
                                     FactoryAssembly(),
                                     UIConfiguratorsAssembly(),
                                     NetworkAssembly(),
                                     ParserAssembly(),
                                     TargetAssembly(),
                                     StoreAssembly()])
    }
    
    private func setupCredentials() {
        let parser = ApiKeyParser()
        let service = ApiKeyService(parser: parser)
        let key = service.getKey()
        YMKMapKit.setApiKey(key)
    }
    
    private func setupProgressHUD() {
        SVProgressHUD.setHapticsEnabled(true)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.6))
    }
}
