//
//  MapTreePointMapper.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import Foundation


final class MapTreePointMapper: Mapper {

    func mapModel(_ entity: MapTreePointEntity) -> Tree {
        var tree = Tree(id: entity.id,
                        latitude: entity.latitude,
                        longitude: entity.longitude)
        tree.diameterOfCrown = entity.crownDiameter.value
        tree.type = entity.type
        return tree
    }
    
    func mapEntity(_ model: Tree) -> MapTreePointEntity {
        let entity = MapTreePointEntity()
        entity.id = model.id
        entity.latitude = model.latitude
        entity.longitude = model.longitude
        entity.crownDiameter.value = model.diameterOfCrown
        entity.type = model.type
        return entity
    }
}
