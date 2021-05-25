//
//  StoreAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Swinject


final class StoreAssembly: Assembly {
    
    func assemble(container: Container) {
        container.autoregister(RealmConfigurationProviderProtocol.self, initializer: RealmConfigurationProvider.init)
        container.register(Store.self) { r in
            let configProvider = r.resolve(RealmConfigurationProviderProtocol.self)!
            return RealmStore(configuration: configProvider.getConfiguration())
        }
    }
}
