//
//  TreeEditorInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import RxSwift


final class TreeEditorInteractor: AnyInteractor<TreeEditorViewOutput, TreeEditorViewInput> {
    
    // MARK: Private Properties
    
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
                .subscribe()
            
            output.didTapSave.subscribe(onNext: { [weak self] in self?.didTapSave() })
        }
        return TreeEditorViewInput()
    }
    
    
    // MARK: Private
    
    private func didTapSave() {
        // save data
        
        output?.didSave()
    }
}
