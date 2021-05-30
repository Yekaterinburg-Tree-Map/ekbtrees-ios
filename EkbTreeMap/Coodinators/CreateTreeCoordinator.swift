//
//  CreateTreeCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.04.2021.
//

import UIKit


final class CreateTreeCoordinator: Coordinator {
    
    // MARK: Private Properties
    
    private var pendingData = TreeEditorPendingData(latitude: 60, longitude: 60)
    private weak var rootViewController: UIViewController?
    private weak var navigationController: UINavigationController?
    private weak var delegate: CoordinatorDelegate?
    
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
        presentPointChooserModule(animated: animated)
    }
    
    func finish(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    
    // MARK: Private
    
    private func presentPointChooserModule(animated: Bool) {
        let factory: MapPointChooserModuleFactory = resolver.resolve()
        let vc = factory.build(with: .init(output: self))
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        navigationController = nvc
        rootViewController?.present(nvc, animated: animated)
    }
    
    private func pushTreeDetailsForm(animated: Bool) {
        let factory: TreeEditorModuleFactory = resolver.resolve(name: TreeEditorFormName.new.rawValue)
        let vc = factory.build(with: .init(output: self, pendingData: pendingData))
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension CreateTreeCoordinator: MapPointChooserModuleOutput {
    
    func didSelectPoint(with location: TreePosition) {
        pendingData.longitude = location.longitude
        pendingData.latitude = location.latitude
        pushTreeDetailsForm(animated: true)
    }
    
    func didTapClose() {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
}


extension CreateTreeCoordinator: TreeEditorModuleOutput {
    
    func module(input: TreeEditorModuleInput, wantsToShowAlert alert: Alert) {
        let alertController = UIAlertController(alert: alert)
        navigationController?.present(alertController, animated: true)
    }
    
    func moduleDidLoad(input: TreeEditorModuleInput) {
        // unused
    }
    
    func moduleDidSave(input: TreeEditorModuleInput) {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
    
    func moduleDidSelectCustomAction(input: TreeEditorModuleInput, type: TreeEditorFormCustomType) {
        // unused
    }
}
