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
    private let visibleClusters = PublishSubject<[TreeClusterRepresentable]>()
    
    
    // MARK: Public
    
    func configure(with output: MapView.InteractorOutput) -> MapView.Input {
        bag.insert {
            output.visiblePoints
                .map { [unowned self] points in self.mapTreeToRepresentable(points) }
                .bind(to: visiblePoints)
            
            output.visibleClusters
                .map { [unowned self] clusters in self.mapClusterToRepresentable(clusters) }
                .bind(to: visibleClusters)
            
            output.startPoint
                .subscribe()
        }
        
        return MapView.Input(moveToPoint: output.startPoint,
                             visiblePoints: visiblePoints,
                             visibleClusters: visibleClusters)
    }
    
    
    // MARK: Private
    
    private func mapTreeToRepresentable(_ points: [Tree]) -> [TreePointRepresentable] {
        points.map { point in
            TreePointRepresentable(id: point.id,
                                   position: .init(latitude: point.latitude, longitude: point.longitude),
                                   circleColor: [UIColor.green, UIColor.blue].randomElement()!,
                                   radius: CGFloat(max((point.diameterOfCrown ?? 5), 5) / 2))
        }
    }
    
    private func mapClusterToRepresentable(_ clusters: [TreeCluster]) -> [TreeClusterRepresentable] {
        clusters.map { cluster in
            TreeClusterRepresentable(position: cluster.position,
                                     countString: "\(cluster.count)",
                                     color: cluster.count < 50 ? .yellow : .red)
        }
    }
}
