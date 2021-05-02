//
//  TreeEditorInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import RxSwift


final class TreeEditorInteractor: AnyInteractor<TreeEditorViewOutput, TreeEditorViewInput> {
    
    // MARK: Private Properties
    
    private let formItemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private var pendingData: TreeEditorPendingData
    private weak var output: TreeEditorModuleOutput?
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    init(pendingData: TreeEditorPendingData,
         output: TreeEditorModuleOutput) {
        self.pendingData = pendingData
        self.output = output
    }
    
    
    // MARK: Public
    
    override func configureIO(with output: TreeEditorViewOutput) -> TreeEditorViewInput? {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapSave
                .subscribe(onNext: { [weak self] in self?.didTapSave() })
        }
        return TreeEditorViewInput(formItems: formItemsSubject)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        configureForm()
    }
    
    private func didTapSave() {
        // save data
        
        output?.didSave()
    }
    
    /// MARK: Form configuration
    
    private func configureForm() {
        let latCell = configureBaseCell(title: "Долгота", subtitle: String(format: "%.5f", pendingData.latitude))
        let longCell = configureBaseCell(title: "Широта", subtitle: String(format: "%.5f", pendingData.longitude))
        let speciesCell = configurePickerCell(title: "Порода",
                                              selectedItem: pendingData.type,
                                              items: ["Хвойное", "Лиственное"], // TODO список пород
                                              action: { [weak self] item in
                                                self?.pendingData.type = item
                                              }
        )
        let heightValue = pendingData.treeHeight == nil ? nil : "\(pendingData.treeHeight)"
        let heightCell = configureEnterDataCell(title: "Высота(м)",
                                                value: heightValue,
                                                placeholder: "Введите высоту в метрах",
                                                action: { [weak self] height in
                                                    
                                                })
        let numberOfTreesValue = pendingData.numberOfTreeTrunks == nil ? nil : "\(pendingData.numberOfTreeTrunks)"
        let numberOfTreesCell = configureEnterDataCell(title: "Число стволов",
                                                   value: numberOfTreesValue,
                                                   placeholder: "Введите число стволов",
                                                   action: { [weak self] number in
                                                    
                                                   })
        let girthValue = pendingData.trunkGirth == nil ? nil : "\(pendingData.trunkGirth)"
        let girthCell = configureEnterDataCell(title: "Обхват дерева(м)",
                                               value: girthValue,
                                               placeholder: "Введите охват дерева",
                                               action: { [weak self] number in
                                                
                                               })
        let crownValue = pendingData.diameterOfCrown == nil ? nil : "\(pendingData.diameterOfCrown)"
        let crownCell = configureEnterDataCell(title: "Диаметр кроны(м)",
                                               value: crownValue,
                                               placeholder: "Введите диаметр кроны",
                                               action: { [weak self] number in
                                                
                                               })
        let firstBranchHeightValue = pendingData.heightOfTheFirstBranch == nil
            ? nil
            : "\(pendingData.heightOfTheFirstBranch)"
        let firstBranchHeightCell = configureEnterDataCell(title: "Высота первой ветви",
                                                           value: firstBranchHeightValue,
                                                           placeholder: "Введите высоту первой ветви",
                                                           action: { [weak self] number in
                                                            
                                                           })
        let visualRatingValue = pendingData.conditionAssessment == nil ? nil : "\(pendingData.conditionAssessment)"
        let visualRatingCell = configurePickerCell(title: "Визуальное состояние",
                                                   selectedItem: visualRatingValue,
                                                   items: ["1", "2", "3", "4", "5"], // TODO состояния
                                                   action: { [weak self] number in
                                                    
                                                   })
        
        let items = [latCell,
                     longCell,
                     speciesCell,
                     heightCell,
                     numberOfTreesCell,
                     girthCell,
                     crownCell,
                     firstBranchHeightCell, visualRatingCell]
        
        formItemsSubject.onNext(items)
    }
    
    private func configureBaseCell(title: String, subtitle: String) -> ViewRepresentableModel {
        GenericViewModel<TreeEditorDataCell>(data: .init(title: title, subtitle: subtitle))
    }
    
    private func configurePickerCell(title: String,
                                     selectedItem: String? = nil,
                                     items: [String],
                                     action: @escaping (String?) -> ()) -> ViewRepresentableModel {
        let data = TreeEditorPickerCell.DisplayData(title: title,
                                                    value: selectedItem,
                                                    pickerValues: items,
                                                    action: action)
        return GenericViewModel<TreeEditorPickerCell>(data: data)
    }
    
    private func configureEnterDataCell(title: String,
                                        value: String?,
                                        placeholder: String,
                                        action: @escaping (String) -> ()) -> ViewRepresentableModel {
        let data = TreeEditorEnterDataCell.DisplayData(title: title,
                                                       placeholder: placeholder,
                                                       data: value,
                                                       action: action)
        return GenericViewModel<TreeEditorEnterDataCell>(data: data)
    }
}
