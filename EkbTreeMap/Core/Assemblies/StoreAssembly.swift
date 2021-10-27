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
        
        container.autoregister(MapTreePointMapper.self, initializer: MapTreePointMapper.init)
        container.autoregister(MapClusterMapper.self, initializer: MapClusterMapper.init)
        container.autoregister(TileDataMapper.self, initializer: TileDataMapper.init)
        container.autoregister(UploadPhotoMapper.self, initializer: UploadPhotoMapper.init)
    }
}
