//
//  FactoryAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 09.05.2021.
//

import Swinject
import SwinjectAutoregistration


final class FactoryAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.autoregister(MapViewModuleFactory.self, initializer: MapViewModuleFactory.init)
        container.autoregister(LoginModuleFactory.self, initializer: LoginModuleFactory.init)
        container.autoregister(MapObserverModuleFactory.self, initializer: MapObserverModuleFactory.init)
        container.autoregister(MapPointChooserModuleFactory.self, initializer: MapPointChooserModuleFactory.init)
        
        TreeEditorFormName.allCases.forEach { name in
            container.register(TreeEditorModuleFactory.self, name: name.rawValue) { r in
                TreeEditorModuleFactory(formManager: r.resolve(TreeEditorFormManagerProtocol.self, name: name.rawValue)!,
                                        formFormatter: r~>)
            }
        }
        
        container.autoregister(TreeDetailsModuleFactory.self, initializer: TreeDetailsModuleFactory.init)
        container.autoregister(PhotoPickerFactory.self, initializer: PhotoPickerFactory.init)
        container.autoregister(PhotoViewerFactory.self, initializer: PhotoViewerFactory.init)
    }
}
