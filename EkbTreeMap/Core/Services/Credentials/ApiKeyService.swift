//
//  ApiKeyService.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.04.2021.
//

import SwiftyJSON


protocol ApiKeyServiceProtocol {
    
    func getKey() -> String
}


final class ApiKeyService: ApiKeyServiceProtocol {
    
    // MARK: Private Properties
    
    private let parser: ApiKeyParser
    
    
    // MARK: Lifecycle
    
    init(parser: ApiKeyParser) {
        self.parser = parser
    }
    
    
    // MARK: Public
    
    func getKey() -> String {
        let url = Bundle.main.url(forResource: "credentials", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        let json = try! JSON(data: data)
        return parser.parse(json)
    }
}
