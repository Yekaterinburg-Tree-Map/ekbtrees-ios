//
//  ParserAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Swinject


final class ParserAssembly: Assembly {
    
    func assemble(container: Container) {
        container.autoregister(CompactTreeInfoParser.self, initializer: CompactTreeInfoParser.init)
        container.autoregister(TreeRegionParser.self, initializer: TreeRegionParser.init)
        container.autoregister(SingleClusterParser.self, initializer: SingleClusterParser.init)
        container.autoregister(ClusterRegionParser.self, initializer: ClusterRegionParser.init)
        container.autoregister(TreeInfoParser.self, initializer: TreeInfoParser.init)
        container.autoregister(TreeFilesParser.self, initializer: TreeFilesParser.init)
    }
}
