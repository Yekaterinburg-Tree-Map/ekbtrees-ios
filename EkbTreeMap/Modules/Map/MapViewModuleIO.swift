//
//  MapViewModuleIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import RxSwift


struct MapViewModule {
    
    struct Input {
        
        var moveToPoint: Observable<TreePosition> = .never()
    }
    
    struct Output {
        
        var didTapPoint: Observable<Int> = .never()
        var didTapOnMap: Observable<TreePosition> = .never()
        var didChangeVisibleRegion: Observable<MapViewVisibleRegionPoints> = .never()
    }
}


protocol MapViewModuleConfigurable: AnyObject {
    
    func configure(with: MapViewModule.Output) -> MapViewModule.Input
}
