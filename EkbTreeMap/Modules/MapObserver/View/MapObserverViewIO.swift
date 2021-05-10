//
//  MapObserverViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import RxSwift


struct MapObserverView {
    
    struct Input {
        
        var annotationView: Observable<TreeAnnotationState> = .never()
        var addButtonImage: Observable<UIImage?> = .never()
        var embedVCFromFactory: Observable<() -> (UIViewController)> = .never()
    }
    
    struct Output {
        
        var didLoad: Observable<Void> = .never()
        var didTapMoreButton: Observable<Void> = .never()
        var didTapAdd: Observable<Void> = .never()
    }
    
    struct InteractorOutput {
        
        var annotationData: Observable<TreePoint?> = .never()
        var authorizationState: Observable<AuthorizationState> = .never()
        var embedVCFromFactory: Observable<() -> (UIViewController)> = .never()
    }
}


protocol MapObserverViewConfigurable {
    
    func configure(with output: MapObserverView.Output) -> MapObserverView.Input
}

protocol MapObserverViewInteractorConfigurable {
    
    func configure(with output: MapObserverView.InteractorOutput) -> MapObserverView.Input
}
