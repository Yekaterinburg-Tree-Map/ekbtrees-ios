//
//  MapObserverModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import UIKit


final class MapObserverModuleFactory: Factory {
    
    struct Context {
        let output: MapObserverModuleOutput
    }
    
    // MARK: Private Properties
    
    private let mapViewFactory: MapViewModuleFactory
    
    
    // MARK: Lifecycle
    
    init(mapViewFactory: MapViewModuleFactory) {
        self.mapViewFactory = mapViewFactory
    }
    

    func build(with context: Context) -> UIViewController {
        let presenter = MapObserverPresenter()
        let interactor = MapObserverInteractor(presenter: presenter,
                                               mapViewFactory: mapViewFactory,
                                               output: context.output)
        let vc = MapObserverViewController.instantiate(with: interactor)
        return vc
    }
}
