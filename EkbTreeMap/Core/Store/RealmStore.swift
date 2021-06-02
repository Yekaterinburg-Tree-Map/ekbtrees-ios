//
//  RealmStore.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RxSwift
import RealmSwift


final class RealmStore: Store {
    
    // MARK: Private Properties
    
    private let configuration: Realm.Configuration
    private let bag = DisposeBag()
    
    private var realm: Realm {
        try! Realm(configuration: configuration)
    }
    
    
    // MARK: Lifecycle
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    
    // MARK: Internal
    
    func createOrUpdate<Entity: Object>(entity: Entity) {
        do {
            try realm.write {
                realm.add(entity, update: .all)
            }
        } catch {
            // log
        }
    }
    
    func createOrUpdate<Entity: Object>(entities: [Entity]) {
        do {
            try realm.write {
                entities.forEach {
                    realm.add($0, update: .all)
                }
            }
        } catch {
            // log
        }
    }
    
    func delete<Entity: Object>(entity: Entity, predicate: String) {
        let entities = realm.objects(Entity.self).filter(predicate)
        
        do {
            try realm.write {
                realm.delete(entities)
            }
        } catch {
            // log
        }
    }
    
    func deleteAll<Entity: Object>(of type: Entity.Type) {
        let entities = realm.objects(type)
        do {
            try realm.write {
                realm.delete(entities)
            }
        } catch {
            // log
        }
    }
    
    func fetchAndNotify<Entity: Object>(of type: Entity.Type, predicate: String) -> Observable<Entity> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create {}
            }
            
            let token = self.realm.objects(type).filter(predicate).observe { result in
                switch result {
                case .initial(let entities), .update(let entities, _, _, _):
                    observer.onNext(entities.first)
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                token.invalidate()
            }
        }
        .compactMap { $0 }
    }
    
    func fetchAll<Entity: Object>(of type: Entity.Type) -> Observable<[Entity]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create {}
            }
            let token = self.realm.objects(type).observe { result in
                switch result {
                case .initial(let entities), .update(let entities, _, _, _):
                    observer.onNext(Array(entities))
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                token.invalidate()
            }
        }
    }
    
    func fetchAllAndMap<T: Mapper>(mapper: T) -> Observable<[T.Model]> {
        fetchAll(of: T.Entity.self)
            .map { entities in
                entities.map(mapper.mapModel)
            }
    }
}
