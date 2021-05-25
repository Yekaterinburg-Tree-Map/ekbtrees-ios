//
//  CompactTreeInfoParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import SwiftyJSON


final class CompactTreeInfoParser: NetworkParser {
    
    func parse(data: JSON) throws -> Tree {
        let point = data["geographicalPoint"]
        
        guard
            let id = data["id"].int,
            let latitude = point["latitude"].double,
            let longitude = point["longitude"].double else
        {
            throw NetworkError.parseFailed
        }
        
        var tree = Tree(id: id, latitude: latitude, longitude: longitude)
        tree.type = data["type"].string
        tree.diameterOfCrown = data["diameterOfCrown"].double
        return tree
    }
}
