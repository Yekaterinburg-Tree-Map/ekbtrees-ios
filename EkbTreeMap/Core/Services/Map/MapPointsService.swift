//
//  MapPointsService.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RxSwift


protocol MapPointsServiceProtocol {
    
    func fetchTrees(in region: MapViewVisibleRegionPoints) -> Observable<Void>
    func fetchClusters(in region: MapViewVisibleRegionPoints) -> Observable<Void>
}


final class MapPointsService: MapPointsServiceProtocol {
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    
    private let resolver: IResolver
    private let networkService: NetworkServiceProtocol
    private let pointsParser: TreeRegionParser
    private let clusterParser: ClusterRegionParser
    private let treeRepository: TreePointsRepositoryProtocol
    private let areaToTilesConverter: AreaToTilesConverting
    
    
    // MARK: Lifecycle
    
    init(resolver: IResolver,
         networkService: NetworkServiceProtocol,
         pointsParser: TreeRegionParser,
         clusterParser: ClusterRegionParser,
         treeRepository: TreePointsRepositoryProtocol,
         areaToTilesConverter: AreaToTilesConverting) {
        self.resolver = resolver
        self.networkService = networkService
        self.pointsParser = pointsParser
        self.clusterParser = clusterParser
        self.treeRepository = treeRepository
        self.areaToTilesConverter = areaToTilesConverter
    }
    
    
    // MARK: Public
    
    
    func fetchTrees(in region: MapViewVisibleRegionPoints) -> Observable<Void> {
        .empty()
    }
    
    func fetchClusters(in region: MapViewVisibleRegionPoints) -> Observable<Void> {
        .empty()
    }
    
    
    // MARK: Private

    private func updateTrees(for region: MapViewVisibleRegionPoints) {
        let position = getFullPosition(for: region)
        let params = GetTreesByRegionTarget.Parameters(x1: position.topLeftPosition.latitude,
                                                       x2: position.bottomRightPosition.latitude,
                                                       y1: position.topLeftPosition.longitude,
                                                       y2: position.bottomRightPosition.longitude)
        let target: GetTreesByRegionTarget = resolver.resolve(arg: params)
        networkService.sendRequest(target, parser: pointsParser)
            .subscribe(onNext: { data in
                print(data)
            })
            .disposed(by: bag)
    }
    
    private func updateClusters(for region: MapViewVisibleRegionPoints) {
        let position = getFullPosition(for: region)
        let params = GetClasterByRegionTarget.Parameters(x1: position.topLeftPosition.latitude,
                                                         x2: position.bottomRightPosition.latitude,
                                                         y1: position.topLeftPosition.longitude,
                                                         y2: position.bottomRightPosition.longitude)
        let target: GetClasterByRegionTarget = resolver.resolve(arg: params)
        networkService.sendRequest(target, parser: clusterParser)
            .subscribe()
            .disposed(by: bag)
    }
    
    private func getFullPosition(for region: MapViewVisibleRegionPoints) -> MapViewVisibleTiles {
        areaToTilesConverter.processVisibleArea(region)
    }
}
