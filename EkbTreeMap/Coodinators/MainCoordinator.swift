//
//  MainCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import UIKit


final class MainCoordinator: ParentCoordinator {
    
    // MARK: Public Properties
    
    var childCoordinators: [Coordinator] = []
    
    
    // MARK: Private Properties
    
    private weak var rootController: UITabBarController?
    
    
    // MARK: Lifecycle
    
    init(rootController: UITabBarController) {
        self.rootController = rootController
    }
    
    
    // MARK: Public
    
    func start(animated: Bool) {
        appendMapCoordinator()
    }
    
    func finish(animated: Bool) {
        // unused
    }
    
    
    // MARK: Private
    
    private func appendMapCoordinator() {
        guard let tabBar = rootController else {
            return
        }
        let coordinator = MapCoordinator(tabBarController: tabBar)
        childCoordinators.append(coordinator)
        coordinator.start(animated: false)
    }
}
