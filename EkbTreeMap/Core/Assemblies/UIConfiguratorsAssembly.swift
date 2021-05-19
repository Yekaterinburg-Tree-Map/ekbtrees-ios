//
//  UIConfiguratorsAssembly.swift
//  EkbTreeMap
//
//  Created by s.petrov on 09.05.2021.
//

import Swinject
import SwinjectAutoregistration
import YPImagePicker


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
        
        container.register(YPImagePickerConfiguration.self) { _ in
            var configuration = YPImagePickerConfiguration()
            configuration.showsPhotoFilters = false
            configuration.shouldSaveNewPicturesToAlbum = false
            configuration.startOnScreen = .library
            configuration.library.defaultMultipleSelection = true
            configuration.library.maxNumberOfItems = 10
            configuration.library.isSquareByDefault = false
            return configuration
        }
        .inObjectScope(.container)
    }
}
