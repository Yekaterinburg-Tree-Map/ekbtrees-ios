//
//  TreeDetailsFormFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import Foundation


protocol TreeDetailsFormFactoryProtocol {
    
    func setupFields(tree: Tree) -> [ViewRepresentableModel]
}


class TreeDetailsFormFactory: TreeDetailsFormFactoryProtocol {
    
    // MARK: Public
    
    func setupFields(tree: Tree) -> [ViewRepresentableModel] {
        []
    }
    
    
    // MARK: Private
    
    private func setupBaseCell(title: String, subtitle: String) -> ViewRepresentableModel {
        GenericViewModel<TreeEditorDataCell>(data: .init(title: title, subtitle: subtitle))
    }
}
