//
//  TreeDetailsModuleOutput.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import Foundation


protocol TreeDetailsModuleInput: AnyObject {
    
}

protocol TreeDetailsModuleOutput: AnyObject {
    
    func moduleWantsToChangeDetails(input: TreeDetailsModuleInput)
    func moduleWantsToClose(input: TreeDetailsModuleInput)
}
