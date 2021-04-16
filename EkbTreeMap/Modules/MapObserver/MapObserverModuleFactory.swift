//
//  MapObserverModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import UIKit


final class MapObserverModuleFactory: Factory {
    
    
    func build(with: Void) -> UIViewController {
        let presenter = MapObserverPresenter()
        let interactor = MapObserverInteractor(presenter: presenter)
        let vc = MapObserverViewController.instantiate(with: interactor)
        return vc
    }
}
