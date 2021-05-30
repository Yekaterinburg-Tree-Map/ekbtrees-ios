//
//  TreeInfoParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.05.2021.
//

import SwiftyJSON


final class TreeInfoParser: NetworkParser {
    
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
        tree.treeHeight = data["treeHeight"].double
        tree.numberOfTreeTrunks = data["numberOfTreeTrunks"].int
        tree.trunkGirth = data["trunkGirth"].double
        tree.heightOfTheFirstBranch = data["heightOfTheFirstBranch"].double
        tree.conditionAssessment = data["conditionAssessment"].int
        tree.age = data["age"].int
        tree.fileIds = data["fileIds"].arrayValue.compactMap { $0.int }
        
        return tree
    }
}
