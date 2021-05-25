//
//  Tree.swift
//  EkbTreeMap
//
//  Created by s.petrov on 10.04.2021.
//

import Foundation


struct Tree: Identifiable {
    
    // MARK: Properties
    
    let id: Int
    let latitude: Double
    let longitude: Double
    
    var type: String?
    var treeHeight: Double?
    var numberOfTreeTrunks: Int?
    var trunkGirth: Double?
    var diameterOfCrown: Double?
    var heightOfTheFirstBranch: Double?
    var conditionAssessment: Int?
    var age: Int?
    var treePlantingType: Int?
    var authorId: Int?
    var status: String?
    
    // ??
    var created: Date?
    var updated: Date?
    
    
    // MARK: Lifecycle
    
    init(id: Int, latitude: Double, longitude: Double) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
}
