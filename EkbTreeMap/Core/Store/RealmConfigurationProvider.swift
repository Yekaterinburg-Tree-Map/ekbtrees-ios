//
//  RealmConfigurationProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RealmSwift


protocol RealmConfigurationProviderProtocol {
    
    func getConfiguration() -> Realm.Configuration
}


final class RealmConfigurationProvider: RealmConfigurationProviderProtocol {
    
    func getConfiguration() -> Realm.Configuration {
        Realm.Configuration(schemaVersion: 1)
    }
}
