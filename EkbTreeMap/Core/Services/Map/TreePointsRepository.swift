//
//  TreePointsRepository.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import RxSwift
import SwiftyJSON


protocol TreePointsRepositoryProtocol {
    
    func fetchTreeClusters(for region: MapViewVisibleRegionPoints) -> Observable<[TreeCluster]>
    func fetchTreePoints(for region: MapViewVisibleRegionPoints) -> Observable<[Tree]>
}


class TreePointsRepository: TreePointsRepositoryProtocol {
    
    let store: Store
    let tileMapper: TileDataMapper
    let areaConverter: AreaToTilesConverting
    
    init(store: Store,
         tileMapper: TileDataMapper,
         areaConverter: AreaToTilesConverting) {
        self.store = store
        self.tileMapper = tileMapper
        self.areaConverter = areaConverter
    }
    
    
    func fetchTreeClusters(for region: MapViewVisibleRegionPoints) -> Observable<[TreeCluster]> {
//        store.
        .empty()
    }
    
    func fetchTreePoints(for region: MapViewVisibleRegionPoints) -> Observable<[Tree]> {
        .empty()
    }
}
