//
//  ClustersRegionParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import SwiftyJSON


final class ClusterRegionParser: NetworkParser {
    
    // MARK: Private Properties
    
    private let clusterParser: SingleClusterParser
    
    
    // MARK: Lifecycle
    
    init(clusterParser: SingleClusterParser) {
        self.clusterParser = clusterParser
    }
    
    
    func parse(data: JSON) throws -> [TreeCluster] {
        guard let array = data.array else {
            throw NetworkError.parseFailed
        }
        
        return try array.map(clusterParser.parse)
    }
}
