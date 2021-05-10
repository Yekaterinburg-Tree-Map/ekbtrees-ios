//
//  MapPointChooserIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import RxSwift
import UIKit


struct MapPointChooserView {
    
    struct Input {
        
        var title: Observable<String> = .never()
        var mapFactory: Observable<() -> UIViewController> = .never()
        var doneButtonImage: Observable<UIImage?> = .never()
    }
    
    struct Output {
        
        var didLoad: Observable<Void> = .never()
        var didTapDone: Observable<Void> = .never()
        var didTapClose: Observable<Void> = .never()
    }
}


protocol MapPointChooserConfigurable {
    
    func configure(with output: MapPointChooserView.Output) -> MapPointChooserView.Input
}
