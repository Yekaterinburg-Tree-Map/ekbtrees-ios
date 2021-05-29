//
//  TreeEditorPendingData.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.04.2021.
//

import Foundation


class TreeEditorPendingData {
    
    var latitude: Double
    var longitude: Double
    
    var id: Int?
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
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
