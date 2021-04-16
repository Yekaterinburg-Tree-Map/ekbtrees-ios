//
//  MapViewModuleIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import CoreLocation
import RxSwift


struct MapViewModuleInput {
    
    var moveToPoint: Observable<CLLocationCoordinate2D> = .never()
}


struct MapViewModuleOutput {
    
    var didTapPoint: Observable<String> = .never()
    var didTapOnMap: Observable<CLLocationCoordinate2D> = .never()
    var didChangeVisibleRegion: Observable<MapViewVisibleRegionPoints> = .never()
}


protocol MapViewConfigurable: AnyObject {
    
    func configureIO(with: MapViewModuleOutput) -> MapViewModuleInput
}
