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
    private let resolver: IResolver
    
    
    // MARK: Lifecycle
    
    init(rootController: UITabBarController, resolver: IResolver) {
        self.rootController = rootController
        self.resolver = resolver
    }
    
    
    // MARK: Public
    
    func start(animated: Bool) {
        appendMapCoordinator()
		appendAuthorizationCoordinator()
    }
    
    func finish(animated: Bool) {
        // unused
    }
    
    
    // MARK: Private
    
    private func appendMapCoordinator() {
        guard let tabBar = rootController else {
            return
        }
        let coordinator = MapCoordinator(tabBarController: tabBar, resolver: resolver)
        childCoordinators.append(coordinator)
        coordinator.start(animated: false)
    }
	
	private func appendAuthorizationCoordinator() {
		guard let tabBar = rootController else {
			return
		}
		let coordinator = AuthCoordinator(resolver: resolver, tabBarController: tabBar)
		childCoordinators.append(coordinator)
		coordinator.start(animated: false)
	}
}
