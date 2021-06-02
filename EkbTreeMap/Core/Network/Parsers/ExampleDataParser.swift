//
//  ExampleDataParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 28.03.2021.
//

import Foundation
import SwiftyJSON


class ExampleDataParser {
    
    let internalParser = ExampleTreeParser()
    
    func parse(_ data: JSON) -> [TreePoint] {
        let features = data["features"].arrayValue
        return features.compactMap(internalParser.parse(_:))
    }
}
