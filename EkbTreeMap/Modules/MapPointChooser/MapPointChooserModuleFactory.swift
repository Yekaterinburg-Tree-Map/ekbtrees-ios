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
        let pendingData: TreeEditorPendingData
    }
    
    
    func build(with context: Context) -> MapPointChooserViewController {
        let interactor = MapPointChooserInteractor(pendingData: context.pendingData, output: context.output)
        let vc = MapPointChooserViewController.instantiate(interactor)
        return vc
    }
}
