//
//  TreeEditorViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import RxSwift

struct TreeEditorView {
    
    struct Input {
        
        var title: Observable<String> = .never()
        var formItems: Observable<[ViewRepresentableModel]> = .never()
        var saveButtonTitle: Observable<String> = .never()
        var hudState: Observable<HUDState> = .never()
    }
    
    struct Output {
        
        var didLoad: Observable<Void> = .never()
        var didTapSave: Observable<Void> = .never()
    }
}


protocol TreeEditorConfigurable {
    
    func configure(with output: TreeEditorView.Output) -> TreeEditorView.Input
}
