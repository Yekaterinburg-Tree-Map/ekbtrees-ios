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
        let pendingData: TreeEditorPendingData
    }
    
    func build(with context: Context) -> TreeEditorViewController {
        let interactor = TreeEditorInteractor(pendingData: context.pendingData, output: context.output)
        return TreeEditorViewController.instantiate(with: interactor)
    }
}
