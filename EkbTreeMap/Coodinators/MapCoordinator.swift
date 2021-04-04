//
//  MapCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import UIKit


final class MapCoordinator: ParentCoordinator {
    
    // MARK: Public Properties
    
    var childCoordinators: [Coordinator] = []
    
    
    // MARK: Private Properties
    
    private weak var tabBarController: UITabBarController?
    
    
    // MARK: Lifecycle
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    
    // MARK: Public
    
    func start(animated: Bool) {
        appendMapView()
    }
    
    func finish(animated: Bool) {
        // unused
    }
    
    
    // MARK: Private
    
    private func appendMapView() {
        let factory = MapViewModuleFactory()
        let repository = TreePointsRepository()
        let vc = factory.build(with: .init(repository: repository))
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem = .init(title: "Map", image: nil, tag: 0)
        tabBarController?.append(nvc)
    }
}
