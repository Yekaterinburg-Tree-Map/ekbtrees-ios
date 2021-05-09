//
//  TreeModels.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import Foundation


struct TreeCluster {
    
    let position: TreePosition
    let count: Int
}

struct TreePoint {
    
    let id: String
    let position: TreePosition
    var diameter: Double?
    var species: String
}

struct TreeSpecies {
    
    let id: String
    let name: String
}


struct TreePosition {
    
    var latitude: Double = 0
    var longitude: Double = 0
}
