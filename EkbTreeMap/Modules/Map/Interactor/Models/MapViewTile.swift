//
//  MapViewTile.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Foundation


struct MapViewTile: Equatable, Hashable {
    
    // MARK: Properties
    
    let x: Int
    let y: Int
    let zoom: Int
    
    
    // MARK: Public
    
    static func == (lhs: MapViewTile, rhs: MapViewTile) -> Bool {
        lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.zoom == rhs.zoom
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(zoom)
    }
}
