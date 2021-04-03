//
//  ApiKeyParser.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.04.2021.
//

import Foundation
import SwiftyJSON


final class ApiKeyParser {
    
    func parse(_ data: JSON) -> String {
        data["key"].stringValue
    }
}
