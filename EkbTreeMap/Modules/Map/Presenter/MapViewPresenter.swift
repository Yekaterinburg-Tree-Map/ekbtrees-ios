//
//  MapViewPresenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation
import RxSwift
import RxCocoa


final class MapViewPresenter: MapViewInteractorConfigurable {
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let visiblePoints = PublishSubject<[TreePointRepresentable]>()
    
    
    // MARK: Public
    
    func configure(with output: MapView.InteractorOutput) -> MapView.Input {
        bag.insert {
            output.visiblePoints
                .map { [unowned self] points in self.mapTreeToRepresentable(points) }
                .bind(to: visiblePoints)
        }
        
        return MapView.Input(moveToPoint: output.startPoint,
                             visiblePoints: visiblePoints)
    }
    
    
    // MARK: Private
    
    private func mapTreeToRepresentable(_ points: [Tree]) -> [TreePointRepresentable] {
        points.map { point in
            TreePointRepresentable(id: point.id,
                                   position: .init(latitude: point.latitude, longitude: point.longitude),
                                   circleColor: [UIColor.green, UIColor.blue].randomElement()!,
                                   radius: CGFloat((point.diameterOfCrown ?? 100) / 2))
        }
    }
}
