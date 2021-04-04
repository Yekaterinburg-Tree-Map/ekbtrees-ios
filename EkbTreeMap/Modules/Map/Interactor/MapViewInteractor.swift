//
//  MapViewInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift
import CoreLocation


final class MapViewInteractor: MapViewInteractorConfigurable {
    
    // MARK: Private Properties
    
    private let presenter: MapViewPresenterConfigurable
    private let treeRepository: TreePointsRepositoryProtocol
    
    private let startPointSubject = BehaviorSubject<CLLocationCoordinate2D>(value: .init(latitude: 56.82,
                                                                                         longitude: 60.62))
    private let visiblePointsSubject = PublishSubject<[TreePoint]>()
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    init(presenter: MapViewPresenterConfigurable,
         treeRepository: TreePointsRepositoryProtocol) {
        self.presenter = presenter
        self.treeRepository = treeRepository
    }
    
    
    // MARK: Public
    
    func configureIO(with output: MapViewOutput) -> MapViewInput {
        output.didLoad
            .subscribe(onNext: { [weak self] in self?.didLoad() })
            .disposed(by: bag)
        
        let interactorOutput = MapViewInteractorOutput(startPoint: startPointSubject,
                                                       visiblePoints: visiblePointsSubject)
        return presenter.configureIO(with: interactorOutput)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        let points = treeRepository.fetchTreePoints()
        visiblePointsSubject.onNext(points)
    }
}
