//
//  MapViewVisibleTiles.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import Foundation


struct MapViewVisibleTiles {
    
    let tiles: [MapViewTile]
    let topLeftPosition: TreePosition
    let bottomRightPosition: TreePosition
    let zoom: Int
}
