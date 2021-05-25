//
//  NetworkParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import SwiftyJSON


protocol NetworkParser {
    associatedtype Response
    
    func parse(data: JSON) throws -> Response
}
