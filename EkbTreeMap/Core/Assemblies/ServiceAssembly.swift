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
        container.register(AuthorizationServiceProtocol.self) { r in
            let resolver = IResolverImpl(resolver: r)
            return AuthorizationService(
                resolver: resolver,
                networkService: resolver.resolve(name: NetworkServiceName.common.rawValue)
            )
        }
        
        container.autoregister(PhotoLoaderRepositoryProtocol.self, initializer: PhotoLoaderRepository.init)
            .inObjectScope(.container)
        
        container.autoregister(TreePointsRepositoryProtocol.self, initializer: TreePointsRepository.init)
        
        container.autoregister(PhotoLoaderServiceProtocol.self, initializer: PhotoLoaderService.init)
        container.register(MapPointsServiceProtocol.self) { r in
            let resolver = IResolverImpl(resolver: r)
            return MapPointsService(resolver: resolver,
                                    networkService: resolver.resolve(name: NetworkServiceName.common.rawValue),
                                    pointsParser: r~>,
                                    clusterParser: r~>,
                                    treeRepository: r~>,
                                    areaToTilesConverter: r~>)
        }
        
        container.register(TreeDataServiceProtocol.self) { r in
            let resolver = IResolverImpl(resolver: r)
            return TreeDataService(resolver: resolver,
                                   networkService: resolver.resolve(name: NetworkServiceName.common.rawValue),
                                   treeInfoParser: r~>)
        }
        
        container.autoregister(AreaToTilesConverting.self, initializer: MapVisibleAreaToTilesConverter.init)
    }
}
