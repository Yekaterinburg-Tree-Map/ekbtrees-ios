//
//  ServiceAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 09.05.2021.
//

import Swinject
import SwinjectAutoregistration


final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.autoregister(TreePointsRepositoryProtocol.self, initializer: TreePointsRepository.init)
        container.autoregister(PhotoLocalDataProviding.self, initializer: PhotoLocalDataProvider.init)
        container.autoregister(PhotoRemoteDataProviding.self, initializer: PhotoRemoteDataProvider.init)
        container.autoregister(PhotoDataProviding.self, initializer: PhotoDataProvider.init)
        container.autoregister(PhotoManagerProtocol.self, initializer: PhotoManager.init)
        
        container.autoregister(PhotoLoaderRepositoryProtocol.self, initializer: PhotoLoaderRepository.init)
            .inObjectScope(.container)
        
        container.autoregister(PhotoLoaderServiceProtocol.self, initializer: PhotoLoaderService.init)
        container.register(MapPointsServiceProtocol.self) { r in
            let resolver = IResolverImpl(resolver: r)
            return MapPointsService(resolver: resolver,
                                    networkService: resolver.resolve(name: NetworkServiceName.common.rawValue),
                                    pointsParser: r~>,
                                    clusterParser: r~>,
                                    treeRepository: TreePointsRepository(),
                                    areaToTilesConverter: r~>)
        }
        
        container.autoregister(AreaToTilesConverting.self, initializer: MapVisibleAreaToTilesConverter.init)
    }
}
