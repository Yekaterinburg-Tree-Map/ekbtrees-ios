//
//  TreeDetailsCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit


class TreeDetailsCoordinator: ParentCoordinator {
    
    // MARK: Public Properties
    
    var childCoordinators: [Coordinator] = []
    
    
    // MARK: Private Properties
    
    private weak var rootViewController: UIViewController?
    private weak var navigationController: UINavigationController?
    private weak var delegate: CoordinatorDelegate?
    
    
    // MARK: Lifecycle
    
    init(rootViewController: UIViewController,
         delegate: CoordinatorDelegate) {
        self.rootViewController = rootViewController
        self.delegate = delegate
    }
    
    func start(animated: Bool) {
        presentTreeDetails(animated: animated)
    }
    
    func finish(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    
    // MARK: Private
    
    private func presentTreeDetails(animated: Bool) {
        let factory = TreeDetailsModuleFactory(formFactory: TreeDetailsFormFactory())
        let tree = Tree(id: "", latitude: 60.02, longitude: 50.34)
        let vc = factory.build(with: .init(tree: tree, output: self))
        let nvc = UINavigationController(rootViewController: vc)
        navigationController = nvc
        rootViewController?.present(nvc, animated: animated)
    }
}


extension TreeDetailsCoordinator: TreeDetailsModuleOutput {
    
    func moduleWantsToChangeDetails(input: TreeDetailsModuleInput) {
        // TODO present editor
    }
    
    func moduleWantsToClose(input: TreeDetailsModuleInput) {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
}
