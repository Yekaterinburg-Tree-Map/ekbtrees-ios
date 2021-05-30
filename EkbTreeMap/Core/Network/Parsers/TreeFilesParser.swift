//
//  TreeFilesParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.05.2021.
//

import SwiftyJSON


final class TreeFilesParser: NetworkParser {
    
    func parse(data: JSON) throws -> [RemotePhotoModel] {
        let array = data.arrayValue
        
        return array.compactMap { json -> RemotePhotoModel? in
            guard
                let id = json["id"].int,
                let uri = json["uri"].string,
                let url = URL(string: uri) else
            {
                return nil
            }
            
            return RemotePhotoModel(id: id, url: url)
        }
    }
}
