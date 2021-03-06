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
    
    let id: Int
    let position: TreePosition
    var diameter: Double?
    var species: String
}

struct TreeSpecies {
    
    let id: String
    let name: String
}


struct TreePosition: Equatable, Hashable {
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    static func == (lhs: TreePosition, rhs: TreePosition) -> Bool {
        lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
