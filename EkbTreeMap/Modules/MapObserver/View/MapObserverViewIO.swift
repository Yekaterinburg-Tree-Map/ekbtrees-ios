//
//  MapObserverViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import RxSwift


struct MapObserverViewInput {
    
    var annotationView: Observable<TreeAnnotationState> = .never()
    var addButtonImage: Observable<UIImage?> = .never()
    var embedVCFromFactory: Observable<() -> (UIViewController)> = .never()
}


struct MapObserverViewOutput {
    
    var didLoad: Observable<Void> = .never()
    var didTapMoreButton: Observable<Void> = .never()
    var didTapAdd: Observable<Void> = .never()
}

struct MapObserverInteractorOutput {
    
    var annotationData: Observable<TreePoint?> = .never()
    var authorizationState: Observable<AuthorizationState> = .never()
    var embedVCFromFactory: Observable<() -> (UIViewController)> = .never()
}
