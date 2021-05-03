//
//  TreeInfoCellType.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import Foundation


enum TreeInfoCellType: CaseIterable {
    case longitude
    case latitude
    case species
    case height
    case numberOfTrees
    case girth
    case crown
    case firstBranchHeight
    case rating
}


// MARK: - TreeEditorFormType + Localization

extension TreeInfoCellType {
    
    var title: String {
        switch self {
        case .latitude:
            return "Широта"
        case .longitude:
            return "Долгота"
        case .species:
            return "Порода"
        case .height:
            return "Высота"
        case .numberOfTrees:
            return "Число стволов"
        case .rating:
            return "Визуальное состояние"
        case .crown:
            return "Диаметр кроны(м)"
        case .firstBranchHeight:
            return "Высота первой ветви"
        case .girth:
            return "Обхват дерева(м)"
        }
    }
}
