//
//  MapViewPresenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift


final class MapViewPresenter: Presenter {
    
    // MARK: Public
    
    func configureIO(with output: MapViewInteractorOutput) -> MapViewInput {
        return MapViewInput(moveToPoint: output.startPoint,
                            visiblePoints: output.visiblePoints)
    }
}
