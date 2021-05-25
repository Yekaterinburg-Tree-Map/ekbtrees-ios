//
//  MapPointsService.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RxSwift


protocol MapPointsServiceProtocol {
    
    func updateTrees(for region: MapViewVisibleRegionPoints)
    func updateClusters(for region: MapViewVisibleRegionPoints)
}


final class MapPointsService: MapPointsServiceProtocol {
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    
    private let resolver: IResolver
    private let networkService: NetworkServiceProtocol
    private let pointsParser: TreeRegionParser
    private let clusterParser: ClusterRegionParser
    private let treeRepository: TreePointsRepositoryProtocol
    
    
    // MARK: Lifecycle
    
    init(resolver: IResolver,
         networkService: NetworkServiceProtocol,
         pointsParser: TreeRegionParser,
         clusterParser: ClusterRegionParser,
         treeRepository: TreePointsRepositoryProtocol) {
        self.resolver = resolver
        self.networkService = networkService
        self.pointsParser = pointsParser
        self.clusterParser = clusterParser
        self.treeRepository = treeRepository
    }
    
    
    // MARK: Public
    
    func updateTrees(for region: MapViewVisibleRegionPoints) {
        let params = GetTreesByRegionTarget.Parameters(x1: region.topLeft.latitude,
                                                       x2: region.bottomRight.latitude,
                                                       y1: region.topLeft.longitude,
                                                       y2: region.bottomRight.longitude)
        let target: GetTreesByRegionTarget = resolver.resolve(arg: params)
        networkService.sendRequest(target, parser: pointsParser)
            .subscribe(onNext: { data in
                print(data)
            })
            .disposed(by: bag)
    }
    
    func updateClusters(for region: MapViewVisibleRegionPoints) {
        let params = GetClasterByRegionTarget.Parameters(x1: region.topLeft.latitude,
                                                       x2: region.bottomRight.latitude,
                                                       y1: region.topLeft.longitude,
                                                       y2: region.bottomRight.longitude)
        let target: GetClasterByRegionTarget = resolver.resolve(arg: params)
        networkService.sendRequest(target, parser: clusterParser)
            .subscribe()
            .disposed(by: bag)
    }
}
