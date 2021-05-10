//
//  TreeEditorModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import UIKit


enum TreeEditorFormName: String, CaseIterable {
    case new
    case edit
}


final class TreeEditorModuleFactory: Factory {
    
    struct Context {
        let output: TreeEditorModuleOutput
        let pendingData: TreeEditorPendingData
    }
    
    // MARK: Private Properties
    
    private let formManager: TreeEditorFormManagerProtocol
    private let formFormatter: TreeEditorFormFormatterProtocol
    
    
    // MARK: Lifecycle
    
    init(formManager: TreeEditorFormManagerProtocol,
         formFormatter: TreeEditorFormFormatterProtocol) {
        self.formManager = formManager
        self.formFormatter = formFormatter
    }
    
    
    // MARK: Public
    
    func build(with context: Context) -> TreeEditorViewController {
        let interactor = TreeEditorInteractor(pendingData: context.pendingData,
                                              formManager: formManager,
                                              formatter: formFormatter,
                                              output: context.output)
        return TreeEditorViewController.instantiate(with: interactor)
    }
}
