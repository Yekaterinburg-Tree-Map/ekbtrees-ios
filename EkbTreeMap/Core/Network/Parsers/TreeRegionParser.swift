//
//  TreeRegionParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import SwiftyJSON


final class TreeRegionParser: NetworkParser {
    
    // MARK: Private Properties
    
    private let treeParser: CompactTreeInfoParser
    
    
    // MARK: Lifecycle
    
    init(treeParser: CompactTreeInfoParser) {
        self.treeParser = treeParser
    }
    
    func parse(data: JSON) throws -> [Tree] {
        guard let array = data.array else {
            throw NetworkError.parseFailed
        }
        
        return try array.map(treeParser.parse)
    }
}
