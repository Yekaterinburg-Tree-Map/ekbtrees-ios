//
//  TreeInfoTarget.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.05.2021.
//

import Moya


final class TreeInfoTarget: Target {
    
    // MARK: Public Structures
    
    struct Parameters {
        let id: Int
    }
    
    // MARK: Public Properties
    
    var baseURL: URL
    
    var path: String {
        "/api/tree/get/\(params.id)"
    }
    
    var method: Method = .get
    
    var sampleData: Data = Data()
    
    var task: Task {
        return .requestPlain
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
