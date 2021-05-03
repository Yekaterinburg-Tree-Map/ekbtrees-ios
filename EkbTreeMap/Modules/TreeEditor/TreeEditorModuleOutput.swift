//
//  TreeEditorModuleOutput.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import Foundation


protocol TreeEditorModuleInput: AnyObject {
    
}


protocol TreeEditorModuleOutput: AnyObject {
    
    func moduleDidSave(input: TreeEditorModuleInput)
    func moduleDidSelectCustomAction(input: TreeEditorModuleInput, type: TreeEditorFormCustomType)
}
