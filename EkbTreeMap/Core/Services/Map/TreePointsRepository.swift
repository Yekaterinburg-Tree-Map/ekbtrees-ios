//
//  TreePointsRepository.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import RxSwift
import SwiftyJSON


protocol TreePointsRepositoryProtocol {
    
    func updateTileData(_ data: [MapViewTileData])
    func fetchTreeClusters(for region: MapViewVisibleRegionPoints) -> Observable<[TreeCluster]>
    func fetchTreePoints(for region: MapViewVisibleRegionPoints) -> Observable<[Tree]>
}


class TreePointsRepository: TreePointsRepositoryProtocol {
    
    let store: Store
    let tileMapper: TileDataMapper
    let areaConverter: AreaToTilesConverting
    
    init(store: Store,
         tileMapper: TileDataMapper,
         areaConverter: AreaToTilesConverting) {
        self.store = store
        self.tileMapper = tileMapper
        self.areaConverter = areaConverter
    }
    
    func updateTileData(_ data: [MapViewTileData]) {
        let entities = data.map(tileMapper.mapEntity)
        store.createOrUpdate(entities: entities)
    }
    
    func fetchTreeClusters(for region: MapViewVisibleRegionPoints) -> Observable<[TreeCluster]> {
        let visibleTiles = areaConverter.processVisibleArea(region)
        return store.fetchAllAndMap(mapper: tileMapper)
            .map { tiles -> [TreeCluster] in
                tiles
                    .filter { visibleTiles.tiles.contains($0.tile) }
                    .map(\.clusters)
                    .reduce([], +)
            }
    }
    
    func fetchTreePoints(for region: MapViewVisibleRegionPoints) -> Observable<[Tree]> {
        let visibleTiles = areaConverter.processVisibleArea(region)
        return store.fetchAllAndMap(mapper: tileMapper)
            .map { tiles -> [Tree] in
                tiles
                    .filter { visibleTiles.tiles.contains($0.tile) }
                    .map(\.treePoints)
                    .reduce([], +)
            }
    }
}
