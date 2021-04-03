//
//  TreePointsRepository.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import Foundation
import SwiftyJSON


protocol TreePointsRepositoryProtocol {
    
    func fetchTreeClusters() -> [TreeCluster]
    func fetchTreePoints() -> [TreePoint]
    func getTree(by id: String) -> TreePoint
}


class TreePointsRepository: TreePointsRepositoryProtocol {
    
    let parser = ExampleDataParser()
    var points: [TreePoint] = []
    
    init() {
        let url = Bundle.main.url(forResource: "trees", withExtension: "geojson")
        let data = try! Data(contentsOf: url!)
        let json = try! JSON(data: data)
        points = parser.parse(json)
        points.map(\.diameter).forEach { print($0) }
    }
    
    func fetchTreeClusters() -> [TreeCluster] {
        []
    }
    
    func fetchTreePoints() -> [TreePoint] {
        points
    }
    
    func getTree(by id: String) -> TreePoint {
        .init(id: "", position: .init(), diameter: nil, species: "")
    }
}
