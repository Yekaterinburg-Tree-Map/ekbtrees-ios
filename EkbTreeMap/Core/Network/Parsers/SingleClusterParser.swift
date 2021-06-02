//
//  SingleClusterParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import SwiftyJSON


final class SingleClusterParser: NetworkParser {
    
    func parse(data: JSON) throws -> TreeCluster {
        let centre = data["centre"]
        guard
            let latitude = centre["latitude"].double,
            let longitude = centre["longitude"].double,
            let count = data["count"].int else
        {
            throw NetworkError.parseFailed
        }
        
        return TreeCluster(position: .init(latitude: latitude, longitude: longitude), count: count)
    }
}
