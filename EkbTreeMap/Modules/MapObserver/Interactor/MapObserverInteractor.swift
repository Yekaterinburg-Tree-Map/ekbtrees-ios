//
//  MapObserverInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 17.04.2021.
//

import UIKit
import RxSwift


final class MapObserverInteractor: MapObserverViewConfigurable {
    
    // MARK: Private Properties
    
    private let mapViewFactory: MapViewModuleFactory
    private let presenter: MapObserverViewInteractorConfigurable
    private weak var output: MapObserverModuleOutput?
    
    private let bag = DisposeBag()
    private let annotationDataSubject = PublishSubject<TreePoint?>()
    private let moduleFactory = PublishSubject<() -> UIViewController>()
    // TODO: add authorization service binidng
    private let authorizationState = BehaviorSubject<AuthorizationState>(value: .authorized)
    
    
    // MARK: Lifecycle
    
    init(presenter: MapObserverViewInteractorConfigurable,
         mapViewFactory: MapViewModuleFactory,
         output: MapObserverModuleOutput) {
        self.presenter = presenter
        self.mapViewFactory = mapViewFactory
        self.output = output
    }
    
    
    func configure(with viewOutput: MapObserverView.Output) -> MapObserverView.Input {
        bag.insert {
            viewOutput.didLoad.subscribe(onNext: { [weak self] in self?.didLoad() })
            viewOutput.didTapAdd.subscribe(onNext: { [weak self] in self?.didTapAdd() })
            viewOutput.didTapMoreButton.subscribe(onNext: { [weak self] in self?.didTapMore() })
        }
        let output = MapObserverView.InteractorOutput(annotationData: annotationDataSubject,
                                                      authorizationState: authorizationState,
                                                      embedVCFromFactory: moduleFactory)
        
        return presenter.configure(with: output)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        let closure: () -> UIViewController = { [unowned self] in
            let context = MapViewModuleFactory.Context(output: self)
            return self.mapViewFactory.build(with: context)
        }
        moduleFactory.onNext(closure)
    }
    
    private func didTapMore() {
        output?.moduleWantsToOpenDetails(input: self, tree: Tree(id: "", latitude: 60.02, longitude: 60.01))
        annotationDataSubject.onNext(nil)
    }
    
    private func didTapPoint(_ id: String) {
        annotationDataSubject.onNext(.init(id: "", position: .init(), diameter: nil, species: "Data for annotation"))
    }
    
    private func didTapAdd() {
        output?.moduleWantsToCreateTree(input: self)
    }
}


// MARK: - MapViewConfigurable

extension MapObserverInteractor: MapViewModuleConfigurable {
    
    func configure(with output: MapViewModule.Output) -> MapViewModule.Input {
        bag.insert {
        output.didTapPoint
            .subscribe(onNext: { [weak self] id in self?.didTapPoint(id) })
        
        output.didChangeVisibleRegion
            .subscribe()
        }
        
        return MapViewModule.Input()
    }
}


// MARK: - MapObserverModuleInput

extension MapObserverInteractor: MapObserverModuleInput {
    
}
