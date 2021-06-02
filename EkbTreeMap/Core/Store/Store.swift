//
//  Store.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RxSwift
import RealmSwift


protocol Store {
    
    func createOrUpdate<Entity: Object>(entity: Entity)
    func createOrUpdate<Entity: Object>(entities: [Entity])
    
    func delete<Entity: Object>(entity: Entity, predicate: String)
    func deleteAll<Entity: Object>(of type: Entity.Type)
    
    func fetchAndNotify<Entity: Object>(of type: Entity.Type, predicate: String) -> Observable<Entity>
    
    func fetchAll<Entity: Object>(of type: Entity.Type) -> Observable<[Entity]>
    func fetchAllAndMap<T: Mapper>(mapper: T) -> Observable<[T.Model]>
}
