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
    
    
    func build(with context: Context) -> MapPointChooserViewController {
        let interactor = MapPointChooserInteractor(output: context.output)
        let vc = MapPointChooserViewController.instantiate(interactor)
        return vc
    }
}
