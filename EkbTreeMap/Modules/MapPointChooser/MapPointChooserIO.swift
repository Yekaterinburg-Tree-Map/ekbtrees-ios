//
//  MapPointChooserIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import RxSwift
import UIKit


struct MapPointChooserViewInput {
    
    var mapFactory: Observable<() -> UIViewController> = .never()
    var doneButtonImage: Observable<UIImage?> = .never()
}


struct MapPointChooserViewOutput {
    
    var didLoad: Observable<Void> = .never()
    var didTapDone: Observable<Void> = .never()
}
