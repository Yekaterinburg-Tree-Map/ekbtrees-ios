//
//  TreeEditorModuleOutput.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//


protocol TreeEditorModuleInput: AnyObject {
    
    func didUpdateLocation(_ location: TreePosition)
}


protocol TreeEditorModuleOutput: AnyObject {
    
    func module(input: TreeEditorModuleInput, wantsToShowAlert alert: Alert)
    func moduleDidLoad(input: TreeEditorModuleInput)
    func moduleDidSave(input: TreeEditorModuleInput)
    func moduleDidSelectCustomAction(input: TreeEditorModuleInput, type: TreeEditorFormCustomType)
}
