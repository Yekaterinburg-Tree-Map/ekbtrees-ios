//
//  TileDataEntity.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import RealmSwift


class TileDataEntity: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var x = 0
    @objc dynamic var y = 0
    @objc dynamic var zoom = 0
    
    let treePoints = List<MapTreePointEntity>()
    let clusters = List<MapClusterEntity>()
    
    static override func primaryKey() -> String? {
        "id"
    }
}
