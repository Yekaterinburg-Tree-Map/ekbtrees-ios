//
//  NetworkAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Moya
import Swinject
import SwinjectAutoregistration


final class NetworkAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(NetworkServiceProtocol.self, name: NetworkServiceName.common.rawValue) { _ in
            let plugins = [AccessTokenPlugin { _ in "" }]
            return NetworkService(plugins: plugins)
        }
    }
}
