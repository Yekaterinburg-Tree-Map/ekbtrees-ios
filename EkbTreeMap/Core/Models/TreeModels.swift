//
//  TreeModels.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import Foundation
import CoreLocation


struct TreeCluster {
    
    let position: CLLocationCoordinate2D
    let count: Int
}

struct TreePoint {
    
    let id: String
    let position: CLLocationCoordinate2D
    var diameter: Double?
    var species: String
}

struct TreeSpecies {
    
    let id: String
    let name: String
}
