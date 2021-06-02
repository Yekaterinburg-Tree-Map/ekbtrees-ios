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
    private let objectsVisitor: MapObjectsVisiting
    
    
    // MARK: Lifecycle
    
    init(repository: TreePointsRepositoryProtocol,
         pointsService: MapPointsServiceProtocol,
         objectsVisitor: MapObjectsVisiting) {
        self.repository = repository
        self.pointsService = pointsService
        self.objectsVisitor = objectsVisitor
    }
    
    
    // MARK: Public
    
    func build(with context: Context) -> UIViewController {
        let presenter = MapViewPresenter()
        let interactor = MapViewInteractor(presenter: presenter,
                                           treeRepository: repository,
                                           pointsService: pointsService,
                                           output: context.output)
        let vc = MapViewController.instantiate(interactor: interactor, objectsVisitor: objectsVisitor)
        return vc
    }
}
