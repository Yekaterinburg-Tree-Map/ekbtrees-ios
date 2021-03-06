//
//  MapViewInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift


final class MapViewInteractor: MapViewConfigurable {
    
    // MARK: Private Properties
    
    private weak var output: MapViewModuleConfigurable?
    
    private let presenter: MapViewInteractorConfigurable
    private let treeRepository: TreePointsRepositoryProtocol
    private let pointsService: MapPointsServiceProtocol
    
    private let startPointSubject = BehaviorSubject<TreePosition>(value: .init(latitude: 56.82,
                                                                               longitude: 60.62))
    private let visiblePointsSubject = PublishSubject<[Tree]>()
    private let visibleClustersSubject = PublishSubject<[TreeCluster]>()
    private let bag = DisposeBag()
    
    private var pointsBag = DisposeBag()
    
    
    // MARK: Output Observables
    
    private let didTapPointSubject = PublishSubject<Int>()
    private let didChangeVisibleRegionSubject = PublishSubject<MapViewVisibleRegionPoints>()
    
    
    // MARK: Lifecycle
    
    init(presenter: MapViewInteractorConfigurable,
         treeRepository: TreePointsRepositoryProtocol,
         pointsService: MapPointsServiceProtocol,
         output: MapViewModuleConfigurable?) {
        self.presenter = presenter
        self.treeRepository = treeRepository
        self.pointsService = pointsService
        self.output = output
    }
    
    
    // MARK: Public
    
    func configure(with output: MapView.Output) -> MapView.Input {
        let visibleRegion = output.didChangeVisibleRegion.share()
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapPoint
                .bind(to: didTapPointSubject)
            
            visibleRegion
                .subscribe(onNext: { [weak self] region in self?.didChangeVisibleRegion(region) })
            
            visibleRegion
                .bind(to: didChangeVisibleRegionSubject)
            
            output.didTapOnMap
                .subscribe(onNext: { [weak self] point in self?.didTapOnMap(point) })
        }
        
        let interactorOutput = MapView.InteractorOutput(startPoint: startPointSubject,
                                                        visiblePoints: visiblePointsSubject,
                                                        visibleClusters: visibleClustersSubject)
        return presenter.configure(with: interactorOutput)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        configureOutputIO()
    }
    
    private func didTapOnMap(_ point: TreePosition) {
        // TODO: check state
    }
    
    private func didChangeVisibleRegion(_ region: MapViewVisibleRegionPoints) {
        pointsBag = DisposeBag()
        if region.zoom > 16 {
            updateTrees(in: region)
        } else {
            updateClusters(in: region)
        }
    }
    
    private func updateTrees(in region: MapViewVisibleRegionPoints) {
        pointsService.fetchTrees(in: region)
            .bind(to: visiblePointsSubject)
            .disposed(by: pointsBag)
    }
    
    private func updateClusters(in region: MapViewVisibleRegionPoints) {
        pointsService.fetchClusters(in: region)
            .bind(to: visibleClustersSubject)
            .disposed(by: pointsBag)
    }
    
    private func configureOutputIO() {
        let moduleOutput = MapViewModule.Output(didTapPoint: didTapPointSubject,
                                                didChangeVisibleRegion: didChangeVisibleRegionSubject)
        let input = output?.configure(with: moduleOutput)
        
        //        input?.moveToPoint
        //            .subscribe(onNext: { [weak self] point in self?.} )
    }
}
