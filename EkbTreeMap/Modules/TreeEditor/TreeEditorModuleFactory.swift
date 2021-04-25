//
//  TreeEditorModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import UIKit


final class TreeEditorModuleFactory: Factory {
    
    struct Context {
        let output: TreeEditorModuleOutput
    }
    
    func build(with context: Context) -> TreeEditorViewController {
        let interactor = TreeEditorInteractor(output: context.output)
        return TreeEditorViewController.instantiate(with: interactor)
    }
}
