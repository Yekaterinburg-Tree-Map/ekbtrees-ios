//
//  Mapper.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RealmSwift


protocol Mapper {
    
    associatedtype Entity: Object
    associatedtype Model
    
    func mapEntity(_ model: Model) -> Entity
    func mapModel(_ entity: Entity) -> Model
}
