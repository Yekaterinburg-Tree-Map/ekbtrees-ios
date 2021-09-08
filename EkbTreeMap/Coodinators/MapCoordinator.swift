//
//  MapCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import UIKit


final class MapCoordinator: ParentCoordinator {
    
    // MARK: Public Properties
    
    var childCoordinators: [Coordinator] = []
    
    
    // MARK: Private Properties
    
    private weak var tabBarController: UITabBarController?
    private weak var rootController: UIViewController?
    private let resolver: IResolver
    
    
    // MARK: Lifecycle
    
    init(tabBarController: UITabBarController, resolver: IResolver) {
        self.tabBarController = tabBarController
        self.resolver = resolver
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
        let factory: MapObserverModuleFactory = resolver.resolve()
        let vc = factory.build(with: .init(output: self))
        vc.tabBarItem = .init(title: "Map", image: nil, tag: 0)
        rootController = vc
        tabBarController?.append(vc)
    }
    
    private func startPointChooserModule() {
        guard let rootViewController = rootController else {
            return
        }
        let coordinator = CreateTreeCoordinator(rootViewController: rootViewController,
                                                resolver: resolver,
                                                delegate: self)
        childCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }
}


extension MapCoordinator: MapObserverModuleOutput {
    
    func moduleWantsToCreateTree(input: MapObserverModuleInput) {
        startPointChooserModule()
    }
    
    func moduleWantsToOpenDetails(input: MapObserverModuleInput, treeId: Tree.ID) {
        guard let rootViewController = rootController else {
            return
        }
        let coordinator = TreeDetailsCoordinator(rootViewController: rootViewController,
                                                 resolver: resolver,
                                                 delegate: self,
                                                 treeId: treeId)
        childCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }
}


extension MapCoordinator: CoordinatorDelegate {
    
    func coordinator(_ coordinator: Coordinator, wantsToFinishAnimated animated: Bool) {
        let coord = childCoordinators.first(where: { $0 === coordinator })
        coord?.finish(animated: animated)
        childCoordinators.removeAll(where: {$0 === coordinator })
    }
}
