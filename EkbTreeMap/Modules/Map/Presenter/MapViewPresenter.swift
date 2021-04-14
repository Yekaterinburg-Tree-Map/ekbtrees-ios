//
//  MapViewPresenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift
import RxCocoa


final class MapViewPresenter: AnyPresenter<MapViewInteractorOutput, MapViewInput> {
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let visiblePoints = PublishSubject<[TreePointRepresentable]>()
    private let annotationViewState = BehaviorSubject<TreeAnnotationState>(value: .hidden)
    private let addButtonImage = ReplayRelay<UIImage?>.create(bufferSize: 1)
    
    
    // MARK: Public
    
    override func configureIO(with output: MapViewInteractorOutput) -> MapViewInput {
        bag.insert {
            output.visiblePoints
                .map { [unowned self] points in self.mapTreeToRepresentable(points) }
                .bind(to: visiblePoints)
            
            output.annotationData
                .subscribe(onNext: { [weak self] point in self?.proceesAnnotationData(point) })
            
            output.authorizationState
                .subscribe(onNext: { [weak self] state in self?.didChangeAuthState(state) })
        }
        
        return MapViewInput(moveToPoint: output.startPoint,
                            visiblePoints: visiblePoints,
                            annotationView: annotationViewState,
                            addButtonImage: addButtonImage.asObservable())
    }
    
    
    // MARK: Private
    
    private func mapTreeToRepresentable(_ points: [TreePoint]) -> [TreePointRepresentable] {
        points.map { point in
            TreePointRepresentable(id: point.id,
                                   position: point.position,
                                   circleColor: [UIColor.green, UIColor.blue].randomElement()!,
                                   radius: CGFloat((point.diameter ?? 2) / 2))
        }
    }
        
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
