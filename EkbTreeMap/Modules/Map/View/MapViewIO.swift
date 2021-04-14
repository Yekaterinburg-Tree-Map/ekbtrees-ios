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
    var didTapMoreButton: Observable<Void> = .never()
    var didTapAdd: Observable<Void> = .never()
}

struct MapViewInput {
    
    var moveToPoint: Observable<CLLocationCoordinate2D> = .never()
    var visiblePoints: Observable<[TreePointRepresentable]> = .never()
    var annotationView: Observable<TreeAnnotationState> = .never()
    var addButtonImage: Observable<UIImage?> = .never()
}

struct MapViewInteractorOutput {
    
    var startPoint: Observable<CLLocationCoordinate2D> = .never()
    var visiblePoints: Observable<[TreePoint]> = .never()
    var annotationData: Observable<TreePoint?> = .never()
    var authorizationState: Observable<AuthorizationState> = .never()
}
