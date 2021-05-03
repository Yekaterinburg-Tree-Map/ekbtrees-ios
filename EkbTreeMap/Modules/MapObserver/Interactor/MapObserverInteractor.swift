//
//  MapObserverInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 17.04.2021.
//

import UIKit
import RxSwift


final class MapObserverInteractor: AnyInteractor<MapObserverViewOutput, MapObserverViewInput> {
    
    // MARK: Private Properties
    
    private let presenter: AnyPresenter<MapObserverInteractorOutput, MapObserverViewInput>
    private weak var output: MapObserverModuleOutput?
    
    private let bag = DisposeBag()
    private let annotationDataSubject = PublishSubject<TreePoint?>()
    private let moduleFactory = PublishSubject<() -> UIViewController>()
    // TODO: add authorization service binidng
    private let authorizationState = BehaviorSubject<AuthorizationState>(value: .authorized)
    
    
    // MARK: Lifecycle
    
    init(presenter: AnyPresenter<MapObserverInteractorOutput, MapObserverViewInput>,
         output: MapObserverModuleOutput) {
        self.presenter = presenter
        self.output = output
    }
    
    
    override func configureIO(with viewOutput: MapObserverViewOutput) -> MapObserverViewInput? {
        bag.insert {
            viewOutput.didLoad.subscribe(onNext: { [weak self] in self?.didLoad() })
            viewOutput.didTapAdd.subscribe(onNext: { [weak self] in self?.didTapAdd() })
            viewOutput.didTapMoreButton.subscribe(onNext: { [weak self] in self?.didTapMore() })
        }
        let output = MapObserverInteractorOutput(annotationData: annotationDataSubject,
                                                 authorizationState: authorizationState,
                                                 embedVCFromFactory: moduleFactory)
        
        return presenter.configureIO(with: output)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        let factory = MapViewModuleFactory()
        let closure: () -> UIViewController = { [unowned self] in
            let context = MapViewModuleFactory.Context(repository: TreePointsRepository(), output: self)
            return factory.build(with: context)
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

extension MapObserverInteractor: MapViewConfigurable {
    
    func configureIO(with output: MapViewModuleOutput) -> MapViewModuleInput {
        output.didTapPoint
            .subscribe(onNext: { [weak self] id in self?.didTapPoint(id) })
            .disposed(by: bag)
        
        output.didChangeVisibleRegion
            .subscribe()
            .disposed(by: bag)
        
        return MapViewModuleInput()
    }
}


// MARK: - MapObserverModuleInput

extension MapObserverInteractor: MapObserverModuleInput {
    
}
