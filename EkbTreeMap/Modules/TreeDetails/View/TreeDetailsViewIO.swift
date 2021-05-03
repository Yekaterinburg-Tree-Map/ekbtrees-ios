//
//  TreeDetailsViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import RxSwift


struct TreeDetailsViewOutput {
    
    var didLoad: Observable<Void> = .never()
    var didTapAction: Observable<Void> = .never()
    var didTapClose: Observable<Void> = .never()
}


struct TreeDetailsViewInput {
    
    var title: Observable<String> = .never()
    var items: Observable<[ViewRepresentableModel]> = .never()
    var buttonTitle: Observable<String> = .never()
    var isButtonHidden: Observable<Bool> = .never()
}
