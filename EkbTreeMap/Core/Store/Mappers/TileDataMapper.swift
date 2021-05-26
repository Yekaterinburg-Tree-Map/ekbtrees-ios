//
//  TileDataMapper.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import Foundation


final class TileDataMapper: Mapper {
    
    private let treePointMapper: MapTreePointMapper
    private let clusterMapper: MapClusterMapper
    
    init(treePointMapper: MapTreePointMapper,
         clusterMapper: MapClusterMapper) {
        self.treePointMapper = treePointMapper
        self.clusterMapper = clusterMapper
    }

    func mapModel(_ entity: TileDataEntity) -> MapViewTileData {
        let tile = MapViewTile(x: entity.x, y: entity.y, zoom: entity.zoom)
        let treePoints: [Tree] = entity.treePoints.map(treePointMapper.mapModel)
        let clusters: [TreeCluster] = entity.clusters.map(clusterMapper.mapModel)
        return MapViewTileData(tile: tile,
                               treePoints: treePoints,
                               clusters: clusters)
    }
    
    func mapEntity(_ model: MapViewTileData) -> TileDataEntity {
        let entity = TileDataEntity()
        entity.id = "\(model.tile.zoom)/\(model.tile.x)/\(model.tile.y)"
        entity.clusters.removeAll()
        entity.clusters.append(objectsIn: model.clusters.map(clusterMapper.mapEntity))
        entity.treePoints.removeAll()
        entity.treePoints.append(objectsIn: model.treePoints.map(treePointMapper.mapEntity))
        return entity
    }
}
