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
    
    func build(with context: Context) -> UIViewController {
        let presenter = MapObserverPresenter()
        let interactor = MapObserverInteractor(presenter: presenter, output: context.output)
        let vc = MapObserverViewController.instantiate(with: interactor)
        return vc
    }
}
