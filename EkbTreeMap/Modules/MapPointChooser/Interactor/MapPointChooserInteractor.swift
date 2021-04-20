//
//  MapPointChooserInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import RxSwift


class MapPointChooserInteractor: AnyInteractor<MapPointChooserViewOutput, MapPointChooserViewInput> {
    
    // MARK: Private Properties
    
    private let moduleFactory = PublishSubject<() -> UIViewController>()
    private let doneButtonImage = BehaviorSubject<UIImage?>(value: UIImage(named: "checkmark"))
    private let bag = DisposeBag()

    
    // MARK: Public
    
    override func configureIO(with output: MapPointChooserViewOutput) -> MapPointChooserViewInput? {
        output.didLoad
            .subscribe(onNext: { [weak self] in self?.didLoad() })
            .disposed(by: bag)
        
        return MapPointChooserViewInput(mapFactory: moduleFactory,
                                        doneButtonImage: doneButtonImage)
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
}


extension MapPointChooserInteractor: MapViewConfigurable {
    
    func configureIO(with output: MapViewModuleOutput) -> MapViewModuleInput {
        return MapViewModuleInput()
    }
}
