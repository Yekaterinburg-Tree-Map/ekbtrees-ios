//
//  MapClusterMapper.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import Foundation


final class MapClusterMapper: Mapper {

    func mapModel(_ entity: MapClusterEntity) -> TreeCluster {
        TreeCluster(position: .init(latitude: entity.latitude,
                                    longitude: entity.longitude),
                    count: entity.count)
    }
    
    func mapEntity(_ model: TreeCluster) -> MapClusterEntity {
        let entity = MapClusterEntity()
        entity.latitude = model.position.latitude
        entity.longitude = model.position.longitude
        entity.count = model.count
        return entity
    }
}
