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
    private weak var detailsInput: TreeDetailsModuleInput?
    
    private let resolver: IResolver
    
    
    // MARK: Lifecycle
    
    init(rootViewController: UIViewController,
         resolver: IResolver,
         delegate: CoordinatorDelegate) {
        self.rootViewController = rootViewController
        self.resolver = resolver
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
        let factory: TreeDetailsModuleFactory = resolver.resolve()
        var tree = Tree(id: 0, latitude: 56.84306, longitude: 60.6135)
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
        nvc.modalPresentationStyle = .fullScreen
        navigationController = nvc
        rootViewController?.present(nvc, animated: animated)
    }
}


extension TreeDetailsCoordinator: TreeDetailsModuleOutput {
    
    func moduleDidLoad(input: TreeDetailsModuleInput) {
        detailsInput = input
    }
    
    func moduleWantsToChangeDetails(input: TreeDetailsModuleInput) {
        guard let rootViewController = navigationController else {
            return
        }
        let coordinator = EditTreeDetailsCoordinator(rootViewController: rootViewController,
                                                     resolver: resolver,
                                                     delegate: self,
                                                     tree: Tree(id: 0, latitude: 0, longitude: 0))
        childCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }
    
    func moduleWantsToClose(input: TreeDetailsModuleInput) {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
    
    func moduleWantsToAddPhotos(input: TreeDetailsModuleInput) {
        let factory: PhotoPickerFactory = resolver.resolve()
        let vc = factory.build(with: self)
        navigationController?.present(vc, animated: true)
    }
    
    func moduleWantToShowPreview(input: TreeDetailsModuleInput, startingIndex: Int, photos: [PhotoModelProtocol]) {
        let factory: PhotoViewerFactory = resolver.resolve()
        let vc = factory.build(with: .init(images: photos, startIndex: startingIndex))
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}


extension TreeDetailsCoordinator: PhotoPickerOutput {
    
    func didSelectPhotos(photos: [UIImage]) {
        detailsInput?.addPhotos(photos)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}


extension TreeDetailsCoordinator: CoordinatorDelegate {
    
    func coordinator(_ coordinator: Coordinator, wantsToFinishAnimated animated: Bool) {
        let coord = childCoordinators.first(where: { $0 === coordinator })
        coord?.finish(animated: animated)
        childCoordinators.removeAll(where: {$0 === coordinator })
    }
}


