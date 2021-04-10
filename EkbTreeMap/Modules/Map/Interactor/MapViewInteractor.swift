//
//  MapViewInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift
import CoreLocation


final class MapViewInteractor: AnyInteractor<MapViewOutput, MapViewInput> {
    
    // MARK: Private Properties
    
    private let presenter: AnyPresenter<MapViewInteractorOutput, MapViewInput>
    private let treeRepository: TreePointsRepositoryProtocol
    
    private let startPointSubject = BehaviorSubject<CLLocationCoordinate2D>(value: .init(latitude: 56.82,
                                                                                         longitude: 60.62))
    private let visiblePointsSubject = PublishSubject<[TreePoint]>()
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    init(presenter: AnyPresenter<MapViewInteractorOutput, MapViewInput>,
         treeRepository: TreePointsRepositoryProtocol) {
        self.presenter = presenter
        self.treeRepository = treeRepository
    }
    
    
    // MARK: Public
    
    override func configureIO(with output: MapViewOutput) -> MapViewInput? {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapPoint
                .subscribe(onNext: { [weak self] point in self?.didTapPoint(point) })
            
            output.didTapOnMap
                .subscribe(onNext: { [weak self] point in self?.didTapOnMap(point) })
            
            output.didChangeVisibleRegion
                .subscribe(onNext: { [weak self] region in self?.didChangeVisibleRegion(region) })
        }
        
        let interactorOutput = MapViewInteractorOutput(startPoint: startPointSubject,
                                                       visiblePoints: visiblePointsSubject)
        return presenter.configureIO(with: interactorOutput)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        let points = treeRepository.fetchTreePoints()
        visiblePointsSubject.onNext(points)
    }
    
    private func didTapPoint(_ id: String) {
        // TODO: show point data
    }
    
    private func didTapOnMap(_ point: CLLocationCoordinate2D) {
        // TODO: check state
    }
    
    private func didChangeVisibleRegion(_ region: MapViewVisibleRegionPoints) {
        // TODO: fetch data for region
    }
}
