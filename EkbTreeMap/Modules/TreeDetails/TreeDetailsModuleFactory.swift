//
//  TreeDetailsModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit


final class TreeDetailsModuleFactory: Factory {
    
    struct Context {
        
        let tree: Tree
        let output: TreeDetailsModuleOutput
    }
    
    // MARK: Private Properties
    
    private let formFactory: TreeDetailsFormFactoryProtocol
    
    
    // MARK: Lifecycle
    
    init(formFactory: TreeDetailsFormFactoryProtocol) {
        self.formFactory = formFactory
    }
    
    
    // MARK: Public
    
    func build(with context: Context) -> TreeDetailsViewController {
        let interactor = TreeDetailsInteractor(tree: context.tree,
                                               formFactory: formFactory,
                                               output: context.output)
        let vc = TreeDetailsViewController.instantiate(with: interactor)
        return vc
    }
}