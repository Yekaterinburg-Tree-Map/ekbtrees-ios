//
//  TargetAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Swinject


final class TargetAssembly: Assembly {
    
    let baseURL = "https://ekb-trees-help.ru"
    
    func assemble(container: Container) {
        
        container.register(GetTreesByRegionTarget.self) { _, params in
            GetTreesByRegionTarget(baseURL: self.baseURL, params: params)
        }
        
        container.register(GetClasterByRegionTarget.self) { _, params in
            GetClasterByRegionTarget(baseURL: self.baseURL, params: params)
        }
    }
    
    
}
