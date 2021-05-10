//
//  MapObserverPresenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 17.04.2021.
//

import RxSwift
import RxRelay


final class MapObserverPresenter: MapObserverViewInteractorConfigurable {
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let annotationViewState = BehaviorSubject<TreeAnnotationState>(value: .hidden)
    private let addButtonImage = ReplayRelay<UIImage?>.create(bufferSize: 1)
    
    
    // MARK: Public
    
    func configure(with output: MapObserverView.InteractorOutput) -> MapObserverView.Input {
        bag.insert {
            output.annotationData
                .subscribe(onNext: { [weak self] point in self?.proceesAnnotationData(point) })
            
            output.authorizationState
                .subscribe(onNext: { [weak self] state in self?.didChangeAuthState(state) })
        }
        
        return MapObserverView.Input(annotationView: annotationViewState,
                                     addButtonImage: addButtonImage.asObservable(),
                                     embedVCFromFactory: output.embedVCFromFactory)
    }
    
    
    // MARK: Private
    
    
    private func proceesAnnotationData(_ point: TreePoint?) {
        guard let point = point else {
            annotationViewState.onNext(.hidden)
            return
        }
        let annotation = TreeAnnotationRepresentable(title: point.species, buttonText: "Еще")
        annotationViewState.onNext(.visible(annotation))
    }
    
    private func didChangeAuthState(_ state: AuthorizationState) {
        let image: UIImage?
        switch state {
        case .authorized:
            image = UIImage(named: "plus")
        case .notAuthorized:
            image = UIImage(named: "user-male")
        }
        addButtonImage.accept(image)
    }
}
