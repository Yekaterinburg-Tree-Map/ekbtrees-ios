//
//  TreeEditorInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import RxSwift
import RxRelay


final class TreeEditorInteractor: TreeEditorConfigurable {
    
    // MARK: Private Properties
    
    private let formItemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private let saveButtonTitleSubject = BehaviorSubject<String>(value: "Сохранить")
    private let titleSubject = BehaviorSubject<String>(value: "Детали")
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let hudSubject = BehaviorRelay<HUDState>(value: .hidden)
    
    private var pendingData: TreeEditorPendingData
    private var formManager: TreeEditorFormManagerProtocol
    private let formatter: TreeEditorFormFormatterProtocol
    private let treeService: TreeDataServiceProtocol
    
    private weak var output: TreeEditorModuleOutput?
    private let bag = DisposeBag()
    
    private var unvalidFields: [TreeInfoCellType] = []
    
    
    // MARK: Lifecycle
    
    init(pendingData: TreeEditorPendingData,
         formManager: TreeEditorFormManagerProtocol,
         formatter: TreeEditorFormFormatterProtocol,
         treeService: TreeDataServiceProtocol,
         output: TreeEditorModuleOutput) {
        self.pendingData = pendingData
        self.formManager = formManager
        self.formatter = formatter
        self.treeService = treeService
        self.output = output
    }
    
    
    // MARK: Public
    
    func configure(with output: TreeEditorView.Output) -> TreeEditorView.Input {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapSave
                .subscribe(onNext: { [weak self] in self?.didTapSave() })
        }
        return TreeEditorView.Input(title: titleSubject,
                                    formItems: formItemsSubject,
                                    saveButtonTitle: saveButtonTitleSubject,
                                    hudState: hudSubject.asObservable())
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
        
        hudSubject.accept(.loading)
        
        treeService.saveTree(pendingData)
            .withUnretained(self)
            .subscribe(onNext: { obj, _ in
                let completion: () -> () = { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.hudSubject.accept(.hidden)
                    self.output?.moduleDidSave(input: self)
                }
                obj.hudSubject.accept(.success(duration: 1.0, completion: completion))
            }, onError: { [weak self] error in
                let completion: () -> () = { [weak self] in
                    self?.hudSubject.accept(.hidden)
                    self?.showError(error: error)
                }
                self?.hudSubject.accept(.failure(duration: 1.0, completion: completion))
            })
            .disposed(by: bag)
    }
    
    private func showError(error: Error) {
        var alert = Alert(message: "Произошла ошибка")
        alert.actions = [.init(title: "ОК")]
        output?.module(input: self, wantsToShowAlert: alert)
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
    
    func didUpdateLocation(_ location: TreePosition) {
        pendingData.latitude = location.latitude
        pendingData.longitude = location.longitude
        configureForm()
    }
}
