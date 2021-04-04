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
    var didTapPoint: Observable<TreePoint> = .never()
}

struct MapViewInput {
    
    var moveToPoint: Observable<CLLocationCoordinate2D> = .never()
    var visiblePoints: Observable<[TreePoint]> = .never()
}

struct MapViewInteractorOutput {
    
    var startPoint: Observable<CLLocationCoordinate2D> = .never()
    var visiblePoints: Observable<[TreePoint]> = .never()
}
