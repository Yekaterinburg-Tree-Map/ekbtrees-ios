//
//  MapViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift


struct MapView {
    
    struct Input {
        
        var moveToPoint: Observable<TreePosition> = .never()
        var visiblePoints: Observable<[TreePointRepresentable]> = .never()
    }
    
    struct Output {
        
        var didLoad: Observable<Void> = .never()
        var didTapPoint: Observable<String> = .never()
        var didTapOnMap: Observable<TreePosition> = .never()
        var didChangeVisibleRegion: Observable<MapViewVisibleRegionPoints> = .never()
    }
    
    struct InteractorOutput {
        
        var startPoint: Observable<TreePosition> = .never()
        var visiblePoints: Observable<[Tree]> = .never()
    }
}

protocol MapViewConfigurable {
    
    func configure(with output: MapView.Output) -> MapView.Input
}

protocol MapViewInteractorConfigurable {
    
    func configure(with output: MapView.InteractorOutput) -> MapView.Input
}
