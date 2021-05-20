//
//  TreeDetailsViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import RxSwift


struct TreeDetailsView {
    
    struct Input {
        
        var title: Observable<String> = .never()
        var items: Observable<[ViewRepresentableModel]> = .never()
        var buttonTitle: Observable<String> = .never()
        var isButtonHidden: Observable<Bool> = .never()
        var mapData: Observable<TreeDetailsMapView.DisplayData> = .never()
        var photos: Observable<(Bool, [TreeDetailsPhotoView.DisplayData])> = .never()
    }
    
    struct Output {
        
        var didLoad: Observable<Void> = .never()
        var didTapAction: Observable<Void> = .never()
        var didTapClose: Observable<Void> = .never()
        var didTapAddPhoto: Observable<Void> = .never()
        var didTapPhoto: Observable<Int> = .never()
        var didTapClosePhoto: Observable<Int> = .never()
    }
}


protocol TreeDetailsConfigurable {
    
    func configure(with output: TreeDetailsView.Output) -> TreeDetailsView.Input
}
