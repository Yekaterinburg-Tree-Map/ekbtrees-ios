//
//  CreateTreeCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.04.2021.
//

import UIKit
import CoreLocation


final class CreateTreeCoordinator: Coordinator {
    
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
        presentPointChooserModule(animated: animated)
    }
    
    func finish(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    
    // MARK: Private
    
    private func presentPointChooserModule(animated: Bool) {
        let factory = MapPointChooserModuleFactory()
        let vc = factory.build(with: .init(output: self))
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        navigationController = nvc
        rootViewController?.present(nvc, animated: animated)
    }
    
    private func pushTreeDetailsForm(animated: Bool) {
        let factory = TreeEditorModuleFactory()
        let vc = factory.build(with: .init(output: self))
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension CreateTreeCoordinator: MapPointChooserModuleOutput {
    
    func didSelectPoint(with location: CLLocationCoordinate2D) {
        pushTreeDetailsForm(animated: true)
    }
    
    func didTapClose() {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
}


extension CreateTreeCoordinator: TreeEditorModuleOutput {
    
    func didSave() {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
}
