//
//  MapViewControllerFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.04.2021.
//

import UIKit


class MapViewModuleFactory: Factory {
    
    // MARK: Public Structures
    
    struct Context {
        let repository: TreePointsRepositoryProtocol
    }
    
    
    // MARK: Public
    
    func build(with context: Context) -> UIViewController {
        let presenter = MapViewPresenter()
        let interactor = MapViewInteractor(presenter: presenter, treeRepository: context.repository)
        let vc = MapViewController.instantiate(interactor: interactor)
        return vc
    }
}
