//
//  UIConfiguratorsAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 09.05.2021.
//

import Swinject
import SwinjectAutoregistration


final class UIConfiguratorsAssembly: Assembly {
    
    func assemble(container: Container) {

        container.autoregister(TreeEditorFormManagerProtocol.self,
                               name: TreeEditorFormName.new.rawValue,
                               initializer: TreeEditorFormManager.init)
        
        container.register(TreeEditorFormManagerProtocol.self, name: TreeEditorFormName.edit.rawValue) { r in
            TreeEditorFormManagerEdit(baseManager: r.resolve(TreeEditorFormManagerProtocol.self,
                                                             name: TreeEditorFormName.new.rawValue)!)
        }
        
        container.autoregister(TreeEditorFormFormatterProtocol.self, initializer: TreeEditorFormFormatter.init)
        container.autoregister(TreeDetailsFormFactoryProtocol.self, initializer: TreeDetailsFormFactory.init)
        container.autoregister(TreeDetailsFlowLayoutDelegate.self, initializer: TreeDetailsFlowLayoutDelegate.init)
    }
}
