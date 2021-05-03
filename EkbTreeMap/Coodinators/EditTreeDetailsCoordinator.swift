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
    private let tree: Tree
    
    
    // MARK: Lifecycle
    
    init(rootViewController: UIViewController, tree: Tree) {
        self.rootViewController = rootViewController
        self.tree = tree
    }
    
    
    // MARK: Public
    
    func start(animated: Bool) {
        presentTreeEditor(animated: animated)
    }
    
    func finish(animated: Bool) {
        
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
        let nvc = UINavigationController(rootViewController: vc)
        if #available(iOS 13.0, *) {
            nvc.isModalInPresentation = true
        }
        nvc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Close",
                                                               style: .plain,
                                                               target: nil, action: nil)
        rootViewController.present(nvc, animated: animated, completion: {   vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
        navigationController = nvc
    }
    
    private func pushCoordinatesChooser() {
        guard let nvc = navigationController else {
            return
        }
        
        let factory = MapPointChooserModuleFactory()
        let vc = factory.build(with: .init(output: self))
    }
}


// MARK: - TreeEditorModuleOutput

extension EditTreeDetailsCoordinator: TreeEditorModuleOutput {
    
    func moduleDidSave(input: TreeEditorModuleInput) {
        
    }
    
    func moduleDidSelectCustomAction(input: TreeEditorModuleInput, type: TreeEditorFormCustomType) {
        switch type {
        case .changeLocation:
            return // TODO
        }
    }
}


// MARK: - MapPointChooserModuleOutput

extension EditTreeDetailsCoordinator: MapPointChooserModuleOutput {
    
    func didSelectPoint(with location: CLLocationCoordinate2D) {
        // TODO: save location
        navigationController?.popViewController(animated: true)
    }
    
    func didTapClose() {
        navigationController?.popViewController(animated: true)
    }
}
