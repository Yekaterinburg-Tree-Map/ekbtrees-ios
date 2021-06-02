//
//  MapTreePointEntity.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import RealmSwift


class MapTreePointEntity: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
    
    var crownDiameter = RealmOptional<Double>()
    @objc dynamic var type: String? = nil
}
