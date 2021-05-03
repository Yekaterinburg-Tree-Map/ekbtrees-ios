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
    
    private let bag = DisposeBag()
    private let titleSubject = BehaviorSubject<String>(value: "Детали")
    private let itemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private let buttonTitleSubject = BehaviorSubject<String>(value: "Редактировать")
    private let authorizationStatus = BehaviorSubject<Bool>(value: true)
    
    
    // MARK: Lifecycle
    
    init(tree: Tree) {
        self.tree = tree
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
        
    }
    
    private func didTapAction() {
        
    }
    
    private func didTapClose() {
        
    }
}
