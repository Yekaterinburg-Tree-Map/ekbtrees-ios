//
//  MapObserverPresenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 17.04.2021.
//

import RxSwift
import RxRelay


final class MapObserverPresenter: AnyPresenter<MapObserverInteractorOutput, MapObserverViewInput> {
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let annotationViewState = BehaviorSubject<TreeAnnotationState>(value: .hidden)
    private let addButtonImage = ReplayRelay<UIImage?>.create(bufferSize: 1)

    
    // MARK: Public
    
    override func configureIO(with output: MapObserverInteractorOutput) -> MapObserverViewInput? {
        bag.insert {
            output.annotationData
                .subscribe()
            
            output.authorizationState
                .subscribe()
        }
        
        return MapObserverViewInput(annotationView: annotationViewState,
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
