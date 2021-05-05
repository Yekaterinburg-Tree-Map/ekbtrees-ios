//
//  TreeDetailsInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import RxSwift


final class TreeDetailsInteractor: TreeDetailsConfigurable {
    
    // MARK: Private Properties
    
    private let tree: Tree
    private let formFactory: TreeDetailsFormFactoryProtocol
    private var output: TreeDetailsModuleOutput?
    
    private let bag = DisposeBag()
    private let titleSubject = BehaviorSubject<String>(value: "Детали")
    private let itemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private let buttonTitleSubject = BehaviorSubject<String>(value: "Редактировать")
    private let isButtonHiddenSubject = BehaviorSubject<Bool>(value: false)
    
    
    // MARK: Lifecycle
    
    init(tree: Tree,
         formFactory: TreeDetailsFormFactoryProtocol,
         output: TreeDetailsModuleOutput) {
        self.tree = tree
        self.formFactory = formFactory
        self.output = output
    }
    
    
    // MARK: Public
    
    func configure(with output: TreeDetailsView.Output) -> TreeDetailsView.Input {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapAction
                .subscribe(onNext: { [weak self] in self?.didTapAction() })
            
            output.didTapClose
                .subscribe(onNext: { [weak self] in self?.didTapClose() })
        }
        return TreeDetailsView.Input(title: titleSubject,
                                     items: itemsSubject,
                                     buttonTitle: buttonTitleSubject,
                                     isButtonHidden: isButtonHiddenSubject)
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
