//
//  CreateTreeCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.04.2021.
//

import UIKit


final class CreateTreeCoordinator: Coordinator {
    
    // MARK: Private Properties
    
    private weak var rootViewController: UIViewController?
    private weak var navigationController: UINavigationController?
    
    
    // MARK: Lifecycle
    
    init(rootViewController: UIViewController,
         delegate: CoordinatorDelegate) {
        self.rootViewController = rootViewController
    }
    
    func start(animated: Bool) {
        presentPointChooserModule(animated: animated)
    }
    
    func finish(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    
    // MARK: Private
    
    private func presentPointChooserModule(animated: Bool) {
        let factory = MapPointChooserModuleFactory()
        let vc = factory.build(with: ())
        let nvc = UINavigationController(rootViewController: vc)
        navigationController = nvc
        rootViewController?.present(nvc, animated: animated)
    }
}
