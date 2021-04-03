//
//  ExampleTreeParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 28.03.2021.
//

import Foundation
import SwiftyJSON


class ExampleTreeParser {
    
    func parse(_ data: JSON) -> TreePoint? {
        let geometry = data["geometry"]
        guard let type = geometry["type"].string, type == "Point" else
        {
            return nil
        }
        
        let coordinates = geometry["coordinates"].arrayObject as? [Double]
        let diameterString = data["properties"]["diameter_crown"].stringValue
        let diameter = Double(diameterString)
        
        return TreePoint(id: UUID().uuidString,
                         position: .init(latitude: coordinates![1], longitude: coordinates![0]),
                         diameter: diameter,
                         species: "")
    }
}
