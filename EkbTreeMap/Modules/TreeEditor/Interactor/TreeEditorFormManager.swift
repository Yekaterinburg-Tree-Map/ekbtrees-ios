//
//  TreeEditorFormFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import Foundation


protocol TreeEditorFormManagerDelegate: AnyObject {
    
    func didUpdateItem(type: TreeInfoCellType, value: String?)
}


protocol TreeEditorFormManagerProtocol {
    
    var delegate: TreeEditorFormManagerDelegate? { get set }
    func configureData(pendingData: TreeEditorPendingData, failedFields: [TreeInfoCellType]) -> [ViewRepresentableModel]
}


class TreeEditorFormManager: TreeEditorFormManagerProtocol {
    
    // MARK: Public Properties
    
    weak var delegate: TreeEditorFormManagerDelegate?
    
    
    // MARK: Private Properties
    
    private var failedFields: [TreeInfoCellType] = []
    

    // MARK: Private Properties
    
    private lazy var cellMapping: [TreeInfoCellType: (TreeEditorPendingData) -> (ViewRepresentableModel)] = [
        .latitude: setupLatitudeCell(_:),
        .longitude: setupLongitudeCell(_:),
        .species: setupSpeciesCell(_:),
        .height: setupHeightCell(_:),
        .numberOfTrees: setupNumberOfTreesCell(_:),
        .firstBranchHeight: setupFirstBranchCell(_:),
        .girth: setupGirthCell(_:),
        .crown: setupCrownCell(_:),
        .rating: setupVisualRatingCell(_:)
    ]
    
    
    // MARK: Public
    
    func configureData(pendingData: TreeEditorPendingData,
                       failedFields: [TreeInfoCellType]) -> [ViewRepresentableModel] {
        self.failedFields = failedFields
        return TreeInfoCellType.allCases
            .compactMap { cellMapping[$0] }
            .map { $0(pendingData) }
    }
    
    
    // MARK: - Specific configuration
    
    private func setupLatitudeCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        configureBaseCell(type: .latitude, subtitle: String(format: "%.5f", pendingData.latitude))
    }
    
    private func setupLongitudeCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        configureBaseCell(type: .longitude, subtitle: String(format: "%.5f", pendingData.longitude))    }
    
    private func setupSpeciesCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        let speciesCell = configurePickerCell(type: .species,
                                              selectedItem: pendingData.type,
                                              items: ["Хвойное", "Лиственное"], // TODO список пород
                                              action: { [weak delegate] item in
                                                delegate?.didUpdateItem(type: .species, value: item)
                                              }
        )
        return speciesCell
    }
    
    private func setupHeightCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        let heightValue = pendingData.treeHeight == nil ? nil : "\(pendingData.treeHeight ?? 0)"
        let heightCell = configureEnterDataCell(type: .height,
                                                value: heightValue,
                                                placeholder: "Введите высоту в метрах",
                                                action: { [weak delegate] item in
                                                    delegate?.didUpdateItem(type: .height, value: item)
                                                  }
        )
        return heightCell
    }
    
    private func setupNumberOfTreesCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        let numberOfTreesValue = pendingData.numberOfTreeTrunks == nil ? nil : "\(pendingData.numberOfTreeTrunks ?? 0)"
        let numberOfTreesCell = configureEnterDataCell(type: .numberOfTrees,
                                                       value: numberOfTreesValue,
                                                       placeholder: "Введите число стволов",
                                                       action: { [weak delegate] item in
                                                        delegate?.didUpdateItem(type: .numberOfTrees, value: item)
                                                       }
        )
        return numberOfTreesCell
    }
    
    private func setupGirthCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        let girthValue = pendingData.trunkGirth == nil ? nil : "\(pendingData.trunkGirth ?? 0)"
        let girthCell = configureEnterDataCell(type: .girth,
                                               value: girthValue,
                                               placeholder: "Введите охват дерева",
                                               action: { [weak delegate] item in
                                                delegate?.didUpdateItem(type: .girth, value: item)
                                              }
        )
        return girthCell
    }
    
    private func setupCrownCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        let crownValue = pendingData.diameterOfCrown == nil ? nil : "\(pendingData.diameterOfCrown ?? 0)"
        let crownCell = configureEnterDataCell(type: .crown,
                                               value: crownValue,
                                               placeholder: "Введите диаметр кроны",
                                               action: { [weak delegate] item in
                                                delegate?.didUpdateItem(type: .crown, value: item)
                                              }
        )
        return crownCell
    }
    
    private func setupFirstBranchCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        let firstBranchHeightValue = pendingData.heightOfTheFirstBranch == nil
            ? nil
            : "\(pendingData.heightOfTheFirstBranch ?? 0)"
        let firstBranchHeightCell = configureEnterDataCell(type: .firstBranchHeight,
                                                           value: firstBranchHeightValue,
                                                           placeholder: "Введите высоту первой ветви",
                                                           action: { [weak delegate] item in
                                                            delegate?.didUpdateItem(type: .firstBranchHeight,
                                                                                    value: item)
                                                          }
        )
        return firstBranchHeightCell
    }
    
    private func setupVisualRatingCell(_ pendingData: TreeEditorPendingData) -> ViewRepresentableModel {
        let visualRatingValue = pendingData.conditionAssessment == nil ? nil : "\(pendingData.conditionAssessment ?? 0)"
        let visualRatingCell = configurePickerCell(type: .rating,
                                                   selectedItem: visualRatingValue,
                                                   items: ["1", "2", "3", "4", "5"], // TODO состояния
                                                   action: { [weak delegate] item in
                                                    delegate?.didUpdateItem(type: .rating, value: item)
                                                  }
        )
        return visualRatingCell
    }
    
    
    
    // MARK: - Base configuration
    
    private func configureBaseCell(type: TreeInfoCellType, subtitle: String) -> ViewRepresentableModel {
        GenericViewModel<TreeEditorDataCell>(data: .init(title: type.title, subtitle: subtitle))
    }
    
    private func configurePickerCell(type: TreeInfoCellType,
                                     selectedItem: String? = nil,
                                     items: [String],
                                     action: @escaping (String?) -> ()) -> ViewRepresentableModel {
        let data = TreeEditorPickerCell.DisplayData(title: type.title,
                                                    value: selectedItem,
                                                    pickerValues: items,
                                                    action: action)
        return GenericViewModel<TreeEditorPickerCell>(data: data)
    }
    
    private func configureEnterDataCell(type: TreeInfoCellType,
                                        value: String?,
                                        placeholder: String,
                                        action: @escaping (String) -> ()) -> ViewRepresentableModel {
        let data = TreeEditorEnterDataCell.DisplayData(title: type.title,
                                                       placeholder: placeholder,
                                                       data: value,
                                                       isFailed: failedFields.contains(type),
                                                       action: action)
        return GenericViewModel<TreeEditorEnterDataCell>(data: data)
    }
}
