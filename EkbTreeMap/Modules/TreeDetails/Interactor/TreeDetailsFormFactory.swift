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
    
    // MARK: Private Properties
    
    private lazy var cellMapping: [TreeInfoCellType: (Tree) -> (ViewRepresentableModel?)] = [
        .latitude: setupLatitudeCell,
        .longitude: setupLongitudeCell,
        .species: setupSpeciesCell,
        .height: setupHeightCell,
        .numberOfTrees: setupNumberOfTreesCell,
        .firstBranchHeight: setupFirstBranchCell,
        .girth: setupGirthCell,
        .crown: setupCrownCell,
        .rating: setupVisualRatingCell
    ]

    
    // MARK: Public
    
    func setupFields(tree: Tree) -> [ViewRepresentableModel] {
        var infoCells = TreeInfoCellType.allCases
            .compactMap { cellMapping[$0] }
            .compactMap { $0(tree) }
        infoCells.insert(setupMapCell(tree), at: 0)
        
        return infoCells
    }
    
    
    // MARK: Private
    
    private func setupMapCell(_ tree: Tree) -> ViewRepresentableModel {
        let data = TreeDetailsMapView.DisplayData(treePoint: .init(latitude: tree.latitude, longitude: tree.longitude))
        return GenericViewModel<TreeDetailsMapView>(data: data)
    }
    
    private func setupLatitudeCell(_ tree: Tree) -> ViewRepresentableModel? {
        return setupBaseCell(type: .latitude, subtitle: String(format: "%.5f", tree.latitude))
    }
    
    private func setupLongitudeCell(_ tree: Tree) -> ViewRepresentableModel? {
        return setupBaseCell(type: .longitude, subtitle: String(format: "%.5f", tree.longitude))
    }

    private func setupSpeciesCell(_ tree: Tree) -> ViewRepresentableModel? {
        guard let subtitle = tree.type else {
            return nil
        }
        return setupBaseCell(type: .species, subtitle: subtitle)
    }

    private func setupHeightCell(_ tree: Tree) -> ViewRepresentableModel? {
        guard let height = tree.treeHeight else {
            return nil
        }
        return setupBaseCell(type: .height, subtitle: String(height))
    }

    private func setupNumberOfTreesCell(_ tree: Tree) -> ViewRepresentableModel? {
        guard let number = tree.numberOfTreeTrunks else {
            return nil
        }
        return setupBaseCell(type: .numberOfTrees, subtitle: String(number))
    }

    private func setupGirthCell(_ tree: Tree) -> ViewRepresentableModel? {
        guard let girth = tree.trunkGirth else {
            return nil
        }
        return setupBaseCell(type: .girth, subtitle: String(girth))
    }

    private func setupFirstBranchCell(_ tree: Tree) -> ViewRepresentableModel? {
        guard let firstBranch = tree.heightOfTheFirstBranch else {
            return nil
        }
        return setupBaseCell(type: .firstBranchHeight, subtitle: String(firstBranch))
    }

    private func setupCrownCell(_ tree: Tree) -> ViewRepresentableModel? {
        guard let crown = tree.diameterOfCrown else {
            return nil
        }
        return setupBaseCell(type: .crown, subtitle: String(crown))
    }

    private func setupVisualRatingCell(_ tree: Tree) -> ViewRepresentableModel? {
        guard let rating = tree.conditionAssessment else {
            return nil
        }
        return setupBaseCell(type: .rating, subtitle: String(rating))
    }

    
    private func setupBaseCell(type: TreeInfoCellType, subtitle: String) -> ViewRepresentableModel {
        GenericViewModel<TreeEditorDataCell>(data: .init(title: type.title, subtitle: subtitle))
    }
}
