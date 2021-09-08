//
//  AuthCoordinator.swift
//  EkbTreeMap
//
//  Created by Pyretttt on 27.08.2021.
//

import UIKit

final class AuthCoordinator: ParentCoordinator {
	
	// MARK: - Outer properties
	
	private weak var tabBarController: UITabBarController?
	var childCoordinators: [Coordinator] = []
	
	// MARK: - Inner properties
	
	private weak var delegate: CoordinatorDelegate?
	private let resolver: IResolver
	
	// MARK: - Lifecycle
	
	init(resolver: IResolver,
		 tabBarController: UITabBarController) {
		self.resolver = resolver
		self.tabBarController = tabBarController
	}
	
	// MARK: - Coodinator
	
	func start(animated: Bool) {
		let factory: LoginModuleFactory = resolver.resolve()
		let vc = factory.build(with: ())
		vc.tabBarItem = .init(title: "Login", image: nil, tag: 1)
		tabBarController?.append(vc)
	}
	
	func finish(animated: Bool) {}
}
