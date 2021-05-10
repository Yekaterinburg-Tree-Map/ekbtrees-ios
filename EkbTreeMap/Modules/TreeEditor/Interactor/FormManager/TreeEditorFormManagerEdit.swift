//
//  TreeEditorFormManagerEdit.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import Foundation


class TreeEditorFormManagerEdit: TreeEditorFormManagerProtocol {
    
    // MARK: Public Properties
    
    var delegate: TreeEditorFormManagerDelegate? {
        didSet {
            baseManager.delegate = delegate
        }
    }
    
    
    // MARK: Private Properties
    
    private var baseManager: TreeEditorFormManagerProtocol
    
    
    // MARK: Lifecycle
    
    init(baseManager: TreeEditorFormManagerProtocol) {
        self.baseManager = baseManager
    }
    
    
    // MARK: Public
    
    func configureData(pendingData: TreeEditorPendingData, failedFields: [TreeInfoCellType]) -> [ViewRepresentableModel] {
        var baseItems = baseManager.configureData(pendingData: pendingData, failedFields: failedFields)
        baseItems.insert(setupChangeLocationCell(), at: 0)
        return baseItems
    }
    
    
    // MARK: Private
    
    func setupChangeLocationCell() -> ViewRepresentableModel {
        let data = TreeEditorActionCell.DisplayData(title: "Изменить местоположение",
                                                    action: { [weak delegate] in
                                                        delegate?.didSelectItem(type: .changeLocation)
                                                    })
        return GenericViewModel<TreeEditorActionCell>(data: data)
    }
}
