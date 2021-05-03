//
//  TreeDetailsInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import RxSwift


final class TreeDetailsInteractor: AnyInteractor<TreeDetailsViewOutput, TreeDetailsViewInput> {
    
    // MARK: Private Properties
    
    private let tree: Tree
    private let formFactory: TreeDetailsFormFactoryProtocol
    private var output: TreeDetailsModuleOutput?
    
    private let bag = DisposeBag()
    private let titleSubject = BehaviorSubject<String>(value: "Детали")
    private let itemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private let buttonTitleSubject = BehaviorSubject<String>(value: "Редактировать")
    private let authorizationStatus = BehaviorSubject<Bool>(value: true)
    
    
    // MARK: Lifecycle
    
    init(tree: Tree,
         formFactory: TreeDetailsFormFactoryProtocol,
         output: TreeDetailsModuleOutput) {
        self.tree = tree
        self.formFactory = formFactory
        self.output = output
    }
    
    
    // MARK: Public
    
    override func configureIO(with output: TreeDetailsViewOutput) -> TreeDetailsViewInput? {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapAction
                .subscribe(onNext: { [weak self] in self?.didTapAction() })
            
            output.didTapClose
                .subscribe(onNext: { [weak self] in self?.didTapClose() })
        }
        return TreeDetailsViewInput(title: titleSubject,
                                    items: itemsSubject,
                                    buttonTitle: buttonTitleSubject,
                                    isButtonHidden: authorizationStatus)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        let items = formFactory.setupFields(tree: tree)
        itemsSubject.onNext(items)
    }
    
    private func didTapAction() {
        output?.moduleWantsToChangeDetails(input: self)
    }
    
    private func didTapClose() {
        output?.moduleWantsToClose(input: self)
    }
}


// MARK: - TreeDetailsModuleInput

extension TreeDetailsInteractor: TreeDetailsModuleInput {
    
}
