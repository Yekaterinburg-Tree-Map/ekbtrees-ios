//
//  TreeEditorModuleOutput.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import CoreLocation


protocol TreeEditorModuleInput: AnyObject {
    
    func didUpdateLocation(_ location: CLLocationCoordinate2D)
}


protocol TreeEditorModuleOutput: AnyObject {
    
    func moduleDidLoad(input: TreeEditorModuleInput)
    func moduleDidSave(input: TreeEditorModuleInput)
    func moduleDidSelectCustomAction(input: TreeEditorModuleInput, type: TreeEditorFormCustomType)
}
