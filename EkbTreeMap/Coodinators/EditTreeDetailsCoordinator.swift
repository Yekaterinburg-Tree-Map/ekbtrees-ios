//
//  EditTreeDetailsCoordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit
import CoreLocation


final class EditTreeDetailsCoordinator: Coordinator {
    
    // MARK: Private Properties
    
    private weak var rootViewController: UIViewController?
    private weak var navigationController: UINavigationController?
    private weak var editorModuleInput: TreeEditorModuleInput?
    private weak var delegate: CoordinatorDelegate?
    
    private let resolver: IResolver
    private let tree: Tree
    
    
    // MARK: Lifecycle
    
    init(rootViewController: UIViewController,
         resolver: IResolver,
         delegate: CoordinatorDelegate,
         tree: Tree) {
        self.rootViewController = rootViewController
        self.resolver = resolver
        self.delegate = delegate
        self.tree = tree
    }
    
    
    // MARK: Public
    
    func start(animated: Bool) {
        presentTreeEditor(animated: animated)
    }
    
    func finish(animated: Bool) {
        rootViewController?.dismiss(animated: true)
    }
    
    
    // MARK: Private
    
    private func presentTreeEditor(animated: Bool) {
        guard let rootViewController = rootViewController else {
            return
        }
        
        let formManager = TreeEditorFormManagerEdit(baseManager: TreeEditorFormManager())
        let factory = TreeEditorModuleFactory(formManager: formManager,
                                              formFormatter: TreeEditorFormFormatter())
        let context = TreeEditorModuleFactory.Context(output: self,
                                                      pendingData: TreeEditorPendingData(latitude: 0, longitude: 0))
        let vc = factory.build(with: context)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть",
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(self.closeTreeEditor))
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        rootViewController.present(nvc, animated: animated, completion: {
        })
        navigationController = nvc
    }
    
    private func pushCoordinatesChooser() {
        guard let nvc = navigationController else {
            return
        }
        
        let factory: MapPointChooserModuleFactory = resolver.resolve()
        let vc = factory.build(with: .init(output: self))
        nvc.pushViewController(vc, animated: true)
    }
    
    @objc private func closeTreeEditor() {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
}


// MARK: - TreeEditorModuleOutput

extension EditTreeDetailsCoordinator: TreeEditorModuleOutput {
    
    func moduleDidLoad(input: TreeEditorModuleInput) {
        editorModuleInput = input
    }
    
    func moduleDidSave(input: TreeEditorModuleInput) {
        delegate?.coordinator(self, wantsToFinishAnimated: true)
    }
    
    func moduleDidSelectCustomAction(input: TreeEditorModuleInput, type: TreeEditorFormCustomType) {
        switch type {
        case .changeLocation:
            pushCoordinatesChooser()
        }
    }
}


// MARK: - MapPointChooserModuleOutput

extension EditTreeDetailsCoordinator: MapPointChooserModuleOutput {
    
    func didSelectPoint(with location: CLLocationCoordinate2D) {
        editorModuleInput?.didUpdateLocation(location)
        navigationController?.popViewController(animated: true)
    }
    
    func didTapClose() {
        navigationController?.popViewController(animated: true)
    }
}
