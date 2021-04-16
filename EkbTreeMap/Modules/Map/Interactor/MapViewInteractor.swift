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
    
    private weak var output: MapViewConfigurable?
    
    private let presenter: AnyPresenter<MapViewInteractorOutput, MapViewInput>
    private let treeRepository: TreePointsRepositoryProtocol
    
    private let startPointSubject = BehaviorSubject<CLLocationCoordinate2D>(value: .init(latitude: 56.82,
                                                                                         longitude: 60.62))
    private let visiblePointsSubject = PublishSubject<[TreePoint]>()
    private let bag = DisposeBag()
    
    
    // MARK: Output Observables
    
    private let didTapPointSubject = PublishSubject<String>()
    private let didChangeVisibleRegionSubject = PublishSubject<MapViewVisibleRegionPoints>()
    
    
    // MARK: Lifecycle
    
    init(presenter: AnyPresenter<MapViewInteractorOutput, MapViewInput>,
         treeRepository: TreePointsRepositoryProtocol,
         output: MapViewConfigurable?) {
        self.presenter = presenter
        self.treeRepository = treeRepository
        self.output = output
    }
    
    
    // MARK: Public
    
    override func configureIO(with output: MapViewOutput) -> MapViewInput? {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapPoint.bind(to: didTapPointSubject)
            let visibleRegion = output.didChangeVisibleRegion.share()
            visibleRegion.subscribe(onNext: { [weak self] region in self?.didChangeVisibleRegion(region) })
            visibleRegion.bind(to: didChangeVisibleRegionSubject)
            
            output.didTapOnMap
                .subscribe(onNext: { [weak self] point in self?.didTapOnMap(point) })
        }
        
        let interactorOutput = MapViewInteractorOutput(startPoint: startPointSubject,
                                                       visiblePoints: visiblePointsSubject)
        return presenter.configureIO(with: interactorOutput)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        configureOutputIO()
        let points = treeRepository.fetchTreePoints()
        visiblePointsSubject.onNext(points)
    }
    
    private func didTapOnMap(_ point: CLLocationCoordinate2D) {
        // TODO: check state
    }
    
    private func didChangeVisibleRegion(_ region: MapViewVisibleRegionPoints) {
        // TODO: fetch data for region
    }
    
    private func configureOutputIO() {
        let moduleOutput = MapViewModuleOutput(didTapPoint: didTapPointSubject,
                                               didChangeVisibleRegion: didChangeVisibleRegionSubject)
        let input = output?.configureIO(with: moduleOutput)
        
//        input?.moveToPoint
//            .subscribe(onNext: { [weak self] point in self?.} )
    }
}
