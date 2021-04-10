//
//  MapViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift
import CoreLocation


struct MapViewOutput {
    
    var didLoad: Observable<Void> = .never()
    var didTapPoint: Observable<String> = .never()
    var didTapOnMap: Observable<CLLocationCoordinate2D> = .never()
    var didChangeVisibleRegion: Observable<MapViewVisibleRegionPoints> = .never()
}

struct MapViewInput {
    
    var moveToPoint: Observable<CLLocationCoordinate2D> = .never()
    var visiblePoints: Observable<[TreePointRepresentable]> = .never()
}

struct MapViewInteractorOutput {
    
    var startPoint: Observable<CLLocationCoordinate2D> = .never()
    var visiblePoints: Observable<[TreePoint]> = .never()
}
