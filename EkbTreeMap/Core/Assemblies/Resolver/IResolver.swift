//
//  IResolver.swift
//  EkbTreeMap
//
//  Created by s.petrov on 09.05.2021.
//

import Swinject
import SwinjectAutoregistration


protocol IResolver {
    
    func resolve<T>() -> T
    func resolve<T>(name: String) -> T
}


final class IResolverImpl: IResolver {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func resolve<T>() -> T {
        resolver~>
    }
    
    func resolve<T>(name: String) -> T {
        resolver.resolve(T.self, name: name)!
    }
}
