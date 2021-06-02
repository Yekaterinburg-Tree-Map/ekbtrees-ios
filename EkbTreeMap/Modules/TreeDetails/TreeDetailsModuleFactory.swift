//
//  TreeDetailsModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit


final class TreeDetailsModuleFactory: Factory {
    
    struct Context {
        
        let treeId: Tree.ID
        let output: TreeDetailsModuleOutput
    }
    
    // MARK: Private Properties
    
    private let formFactory: TreeDetailsFormFactoryProtocol
    private let photoManager: PhotoManagerProtocol
    private let treeService: TreeDataServiceProtocol
    
    
    // MARK: Lifecycle
    
    init(formFactory: TreeDetailsFormFactoryProtocol,
         photoManager: PhotoManagerProtocol,
         treeService: TreeDataServiceProtocol) {
        self.formFactory = formFactory
        self.photoManager = photoManager
        self.treeService = treeService
    }
    
    
    // MARK: Public
    
    func build(with context: Context) -> TreeDetailsViewController {
        let interactor = TreeDetailsInteractor(treeId: context.treeId,
                                               formFactory: formFactory,
                                               photoManager: photoManager,
                                               treeService: treeService,
                                               output: context.output)
        let vc = TreeDetailsViewController.instantiate(with: interactor)
        return vc
    }
}
