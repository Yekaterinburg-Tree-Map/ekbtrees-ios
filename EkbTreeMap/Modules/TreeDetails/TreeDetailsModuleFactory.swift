//
//  TreeDetailsModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit


final class TreeDetailsModuleFactory: Factory {
    
    func build(with: Void) -> TreeDetailsViewController {
        let interactor = TreeDetailsInteractor()
        let vc = TreeDetailsViewController.instantiate(with: interactor)
        return vc
    }
}
