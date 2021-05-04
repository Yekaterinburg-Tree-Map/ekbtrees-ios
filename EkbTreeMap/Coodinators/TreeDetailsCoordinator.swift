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
        let tree = Tree(id: "", latitude: 56.84306, longitude: 60.6135)
        tree.age = 5
        tree.conditionAssessment = 5
        tree.diameterOfCrown = 10
        tree.heightOfTheFirstBranch = 2
        tree.numberOfTreeTrunks = 15
        tree.treeHeight = 20
        tree.type = "Хвойное"
        tree.trunkGirth = 1.5
        let vc = factory.build(with: .init(tree: tree, output: self))
        let nvc = UINavigationController(rootViewController: vc)
        if #available(iOS 13.0, *) {
            nvc.isModalInPresentation = true
        }
        navigationController = nvc
        rootViewController?.present(nvc, animated: animated)
    }
}


extension TreeDetailsCoordinator: TreeDetailsModuleOutput {
    
    func moduleWantsToChangeDetails(input: TreeDetailsModuleInput) {
        guard let rootViewController = navigationController else {
            return
        }
        let coordinator = EditTreeDetailsCoordinator(rootViewController: rootViewController,
                                                     delegate: self,
                                                     tree: Tree(id: "", latitude: 0, longitude: 0))
        childCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }
    
    func moduleWantsToClose(input: TreeDetailsModuleInput) {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
}


extension TreeDetailsCoordinator: CoordinatorDelegate {
    
    func coordinator(_ coordinator: Coordinator, wantsToFinishAnimated animated: Bool) {
        let coord = childCoordinators.first(where: { $0 === coordinator })
        coord?.finish(animated: animated)
        childCoordinators.removeAll(where: {$0 === coordinator })
    }
}
