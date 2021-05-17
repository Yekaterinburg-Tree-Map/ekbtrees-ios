//
//  TreeDetailsModuleOutput.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit


protocol TreeDetailsModuleInput: AnyObject {
    
    func addPhotos(_ photos: [UIImage])
}

protocol TreeDetailsModuleOutput: AnyObject {
    
    func moduleDidLoad(input: TreeDetailsModuleInput)
    func moduleWantsToChangeDetails(input: TreeDetailsModuleInput)
    func moduleWantsToClose(input: TreeDetailsModuleInput)
    func moduleWantsToAddPhotos(input: TreeDetailsModuleInput)
}
