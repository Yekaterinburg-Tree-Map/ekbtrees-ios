//
//  MapViewModuleIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import CoreLocation
import RxSwift


struct MapViewModule {
    
    struct Input {
        
        var moveToPoint: Observable<CLLocationCoordinate2D> = .never()
    }
    
    struct Output {
        
        var didTapPoint: Observable<String> = .never()
        var didTapOnMap: Observable<CLLocationCoordinate2D> = .never()
        var didChangeVisibleRegion: Observable<MapViewVisibleRegionPoints> = .never()
    }
}


protocol MapViewModuleConfigurable: AnyObject {
    
    func configure(with: MapViewModule.Output) -> MapViewModule.Input
}
