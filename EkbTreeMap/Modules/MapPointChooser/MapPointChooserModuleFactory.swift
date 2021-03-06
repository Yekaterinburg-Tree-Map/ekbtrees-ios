//
//  MapPointChooserModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import UIKit


class MapPointChooserModuleFactory: Factory {
    
    struct Context {
        let output: MapPointChooserModuleOutput
    }
    
    // MARK: Private Properties
    
    private let mapViewFactory: MapViewModuleFactory
    
    
    // MARK: Lifecycle
    
    init(mapViewFactory: MapViewModuleFactory) {
        self.mapViewFactory = mapViewFactory
    }
    
    
    func build(with context: Context) -> MapPointChooserViewController {
        let interactor = MapPointChooserInteractor(output: context.output, mapViewFactory: mapViewFactory)
        let vc = MapPointChooserViewController.instantiate(interactor)
        return vc
    }
}
