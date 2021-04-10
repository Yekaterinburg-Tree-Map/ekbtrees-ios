//
//  MapViewPresenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift


final class MapViewPresenter: AnyPresenter<MapViewInteractorOutput, MapViewInput> {
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let visiblePoints = PublishSubject<[TreePointRepresentable]>()
    
    
    // MARK: Public
    
    override func configureIO(with output: MapViewInteractorOutput) -> MapViewInput {
        
        output.visiblePoints
            .map { [unowned self] points in self.mapTreeToRepresentable(points) }
            .bind(to: visiblePoints)
            .disposed(by: bag)
        
        return MapViewInput(moveToPoint: output.startPoint,
                            visiblePoints: visiblePoints)
    }
    
    
    // MARK: Private
    
    private func mapTreeToRepresentable(_ points: [TreePoint]) -> [TreePointRepresentable] {
        points.map { point in
            TreePointRepresentable(id: point.id,
                                   position: point.position,
                                   circleColor: [UIColor.green, UIColor.blue].randomElement()!,
                                   radius: CGFloat((point.diameter ?? 2) / 2))
        }
    }
}
