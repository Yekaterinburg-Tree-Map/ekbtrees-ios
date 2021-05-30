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
        var photosSource: Observable<TreeDetailsPhotoContainerDataSource & TreeDetailsPhotoContainerDelegate> = .never()
        var reloadPhotos: Observable<Void> = .never()
        var hudState: Observable<HUDState> = .never()
    }
    
    struct Output {
        
        var didLoad: Observable<Void> = .never()
        var willAppear: Observable<Void> = .never()
        var didTapAction: Observable<Void> = .never()
        var didTapClose: Observable<Void> = .never()
    }
}


protocol TreeDetailsConfigurable {
    
    func configure(with output: TreeDetailsView.Output) -> TreeDetailsView.Input
}
