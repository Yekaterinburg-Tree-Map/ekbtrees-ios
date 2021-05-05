//
//  MapPointChooserInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import RxSwift
import CoreLocation


class MapPointChooserInteractor: MapPointChooserConfigurable {
    
    // MARK: Private Properties
    
    private let moduleFactory = PublishSubject<() -> UIViewController>()
    private let doneButtonImage = BehaviorSubject<UIImage?>(value: UIImage(named: "checkmark"))
    private let titleSubject = BehaviorSubject<String>(value: "Выбор координат")
    private let bag = DisposeBag()
    
    private var selectedPoint: CLLocationCoordinate2D = .init()
    private weak var output: MapPointChooserModuleOutput?
    
    
    // MARK: Lifecycle
    
    init(output: MapPointChooserModuleOutput) {
        self.output = output
    }
    
    
    // MARK: Public
    
    func configure(with output: MapPointChooserView.Output) -> MapPointChooserView.Input {
        output.didLoad
            .subscribe(onNext: { [weak self] in self?.didLoad() })
            .disposed(by: bag)
        
        output.didTapDone
            .subscribe(onNext: { [weak self] in self?.didTapDone() })
            .disposed(by: bag)
        
        output.didTapClose
            .subscribe(onNext: { [weak self] in self?.didTapClose() })
            .disposed(by: bag)
        
        return MapPointChooserView.Input(title: titleSubject,
                                         mapFactory: moduleFactory,
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
    
    private func didTapDone() {
        output?.didSelectPoint(with: selectedPoint)
    }
    
    private func didTapClose() {
        output?.didTapClose()
    }
}


extension MapPointChooserInteractor: MapViewModuleConfigurable {
    
    func configure(with output: MapViewModule.Output) -> MapViewModule.Input {
        output.didChangeVisibleRegion
            .map(\.center)
            .subscribe(onNext: { [weak self] point in
                self?.selectedPoint.latitude = point.latitude
                self?.selectedPoint.longitude = point.longitude
            })
            .disposed(by: bag)
        
        return MapViewModule.Input()
    }
}
