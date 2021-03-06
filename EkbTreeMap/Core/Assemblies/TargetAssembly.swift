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
        
        container.register(SaveTreeTarget.self) { _, params in
            SaveTreeTarget(baseURL: self.baseURL, params: params)
        }
        
        container.register(TreeInfoTarget.self) { _, params in
            TreeInfoTarget(baseURL: self.baseURL, params: params)
        }
        
        container.register(GetPhotosByTreeIdTarget.self) { _, params in
            GetPhotosByTreeIdTarget(baseURL: self.baseURL, params: params)
        }
        
        container.register(DeletePhotosByIdTarget.self) { _, params in
            DeletePhotosByIdTarget(baseURL: self.baseURL, params: params)
        }
        
        container.register(AttachFileToTreeTarget.self) { _, params in
            AttachFileToTreeTarget(baseURL: self.baseURL, params: params)
        }
    }
}
