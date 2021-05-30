//
//  MapObserverModuleIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.04.2021.
//

import Foundation


protocol MapObserverModuleInput: AnyObject {
    
}

protocol MapObserverModuleOutput: AnyObject {
    
    func moduleWantsToCreateTree(input: MapObserverModuleInput)
    func moduleWantsToOpenDetails(input: MapObserverModuleInput, treeId: Tree.ID)
}
