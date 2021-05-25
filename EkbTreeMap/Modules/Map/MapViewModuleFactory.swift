//
//  MapViewModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.04.2021.
//

import UIKit


class MapViewModuleFactory: Factory {
    
    // MARK: Public Structures
    
    struct Context {
        let output: MapViewModuleConfigurable
    }
    
    // MARK: Private Properties
    
    private let repository: TreePointsRepositoryProtocol
    private let pointsService: MapPointsServiceProtocol
    
    
    // MARK: Lifecycle
    
    init(repository: TreePointsRepositoryProtocol,
         pointsService: MapPointsServiceProtocol) {
        self.repository = repository
        self.pointsService = pointsService
    }
    
    
    // MARK: Public
    
    func build(with context: Context) -> UIViewController {
        let presenter = MapViewPresenter()
        let interactor = MapViewInteractor(presenter: presenter,
                                           treeRepository: repository,
                                           pointsService: pointsService,
                                           output: context.output)
        let vc = MapViewController.instantiate(interactor: interactor)
        return vc
    }
}
