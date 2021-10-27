//
//  MapPointsService.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RxSwift


protocol MapPointsServiceProtocol {
    
    func fetchTrees(in region: MapViewVisibleRegionPoints) -> Observable<[Tree]>
    func fetchClusters(in region: MapViewVisibleRegionPoints) -> Observable<[TreeCluster]>
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
    
    
    func fetchTrees(in region: MapViewVisibleRegionPoints) -> Observable<[Tree]> {
        updateTrees(for: region)
        return treeRepository.fetchTreePoints(for: region)
    }
    
    func fetchClusters(in region: MapViewVisibleRegionPoints) -> Observable<[TreeCluster]> {
        updateClusters(for: region)
        return treeRepository.fetchTreeClusters(for: region)
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
            .map { self.processTrees($0, position: position) }
            .subscribe(onNext: { [weak self] data in
                self?.treeRepository.updateTileData(data)
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
            .map { self.processClusters($0, position: position) }
            .subscribe(onNext: { [weak self] data in
                self?.treeRepository.updateTileData(data)
            })
            .disposed(by: bag)
    }
    
    private func processTrees(_ trees: [Tree], position: MapViewVisibleTiles) -> [MapViewTileData] {
        var data: [MapViewTile: [Tree]] = [:]
        position.tiles.forEach { data[$0] = [] }
        for tree in trees {
            let tile = areaToTilesConverter.processTile(from: .init(latitude: tree.latitude,
                                                                    longitude: tree.longitude),
                                                        zoom: position.zoom)
            var array = data[tile] ?? []
            array.append(tree)
            data[tile] = array
        }
        
        return data.map { key, value in
            MapViewTileData(tile: key, treePoints: value, clusters: [])
        }
    }
    
    private func processClusters(_ clusters: [TreeCluster], position: MapViewVisibleTiles) -> [MapViewTileData] {
        var data: [MapViewTile: [TreeCluster]] = [:]
        position.tiles.forEach { data[$0] = [] }
        for cluster in clusters {
            let tile = areaToTilesConverter.processTile(from: cluster.position,
                                                        zoom: position.zoom)
            var array = data[tile] ?? []
            array.append(cluster)
            data[tile] = array
        }
        
        return data.map { key, value in
            MapViewTileData(tile: key, treePoints: [], clusters: value)
        }
    }
    
    private func getFullPosition(for region: MapViewVisibleRegionPoints) -> MapViewVisibleTiles {
        areaToTilesConverter.processVisibleArea(region)
    }
}
