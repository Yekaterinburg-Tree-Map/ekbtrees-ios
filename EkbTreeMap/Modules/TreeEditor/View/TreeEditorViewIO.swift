//
//  TreeEditorViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import RxSwift


struct TreeEditorViewOutput {
    
    var didLoad: Observable<Void> = .never()
    var didTapSave: Observable<Void> = .never()
}

struct TreeEditorViewInput {
    
    var title: Observable<String> = .never()
    var formItems: Observable<[ViewRepresentableModel]> = .never()
    var saveButtonTitle: Observable<String> = .never()
}
