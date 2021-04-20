//
//  MapPointChooserModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import UIKit


class MapPointChooserModuleFactory: Factory {
    
    
    func build(with: Void) -> MapPointChooserViewController {
        let interactor = MapPointChooserInteractor()
        let vc = MapPointChooserViewController.instantiate(interactor)
        return vc
    }
}
