//
//  TreeEditorInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import RxSwift
import CoreLocation


final class TreeEditorInteractor: AnyInteractor<TreeEditorViewOutput, TreeEditorViewInput> {
    
    // MARK: Private Properties
    
    private let formItemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private let saveButtonTitleSubject = BehaviorSubject<String>(value: "Сохранить")
    private let titleSubject = BehaviorSubject<String>(value: "Детали")
    
    private var pendingData: TreeEditorPendingData
    private var formManager: TreeEditorFormManagerProtocol
    private let formatter: TreeEditorFormFormatterProtocol
    private weak var output: TreeEditorModuleOutput?
    private let bag = DisposeBag()
    
    private var unvalidFields: [TreeInfoCellType] = []
    
    
    // MARK: Lifecycle
    
    init(pendingData: TreeEditorPendingData,
         formManager: TreeEditorFormManagerProtocol,
         formatter: TreeEditorFormFormatterProtocol,
         output: TreeEditorModuleOutput) {
        self.pendingData = pendingData
        self.formManager = formManager
        self.formatter = formatter
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
        return TreeEditorViewInput(title: titleSubject,
                                   formItems: formItemsSubject,
                                   saveButtonTitle: saveButtonTitleSubject)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        formManager.delegate = self
        output?.moduleDidLoad(input: self)
        
        configureForm()
    }
    
    private func didTapSave() {
        if !unvalidFields.isEmpty {
            configureForm()
            return
        }
        // save data
        
        output?.moduleDidSave(input: self)
    }
    
    /// MARK: Form configuration
    
    private func configureForm() {
        let items = formManager.configureData(pendingData: pendingData, failedFields: unvalidFields)
        formItemsSubject.onNext(items)
        unvalidFields = []
    }
}


// MARK: - TreeEditorFormManagerDelegate

extension TreeEditorInteractor: TreeEditorFormManagerDelegate {
    
    func didUpdateItem(type: TreeInfoCellType, value: String?) {
        do {
            switch type {
            case .longitude, .latitude:
                return
            case .species:
                pendingData.type = value
            case .height:
                let height = try formatter.formatDouble(value: value)
                pendingData.treeHeight = height
            case .numberOfTrees:
                let number = try formatter.formatInt(value: value)
                pendingData.numberOfTreeTrunks = number
            case .girth:
                let girth = try formatter.formatDouble(value: value)
                pendingData.trunkGirth = girth
            case .crown:
                let crown = try formatter.formatDouble(value: value)
                pendingData.diameterOfCrown = crown
            case .firstBranchHeight:
                let height = try formatter.formatDouble(value: value)
                pendingData.heightOfTheFirstBranch = height
            case .rating:
                pendingData.conditionAssessment = 0 // TODO mapping
            }
        } catch {
            unvalidFields.append(type)
        }
    }
    
    func didSelectItem(type: TreeEditorFormCustomType) {
        output?.moduleDidSelectCustomAction(input: self, type: type)
    }
}


// MARK: - TreeEditorModuleInput

extension TreeEditorInteractor: TreeEditorModuleInput {
    
    func didUpdateLocation(_ location: CLLocationCoordinate2D) {
        pendingData.latitude = location.latitude
        pendingData.longitude = location.longitude
        configureForm()
    }
}
