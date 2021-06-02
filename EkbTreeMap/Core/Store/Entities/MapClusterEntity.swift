//
//  MapClusterEntity.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import RealmSwift


class MapClusterEntity: Object {
    
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var count = 0
}
