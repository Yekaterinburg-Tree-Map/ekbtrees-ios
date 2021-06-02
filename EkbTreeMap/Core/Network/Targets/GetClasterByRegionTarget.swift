//
//  GetClasterByRegionTarget.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Moya


final class GetClasterByRegionTarget: Target {
    
    // MARK: Public Structures
    
    struct Parameters {
        let x1: Double
        let x2: Double
        let y1: Double
        let y2: Double
    }
    
    enum Keys: String {
        case x1
        case x2
        case y1
        case y2
    }
    
    // MARK: Public Properties
    
    var baseURL: URL
    
    var path: String = "/api/trees-cluster/get-in-region"
    
    var method: Method = .get
    
    var sampleData: Data = Data()
    
    var task: Task {
        let parameters = [Keys.x1.rawValue: params.x1,
                          Keys.y1.rawValue: params.y1,
                          Keys.x2.rawValue: params.x2,
                          Keys.y2.rawValue: params.y2
        ]
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]?
    
    
    // MARK: Private Properties
    
    private let params: Parameters
    
    
    // MARK: Lifecycle
    
    init(baseURL: String, params: Parameters) {
        self.params = params
        guard let url = URL(string: baseURL) else {
            self.baseURL = URL(fileReferenceLiteralResourceName: "")
            return
        }
        self.baseURL = url
    }
}
