//
//  AttachFileToTreeTarget.swift
//  EkbTreeMap
//
//  Created by s.petrov on 06.06.2021.
//

import Moya


final class AttachFileToTreeTarget: Target {
    
    // MARK: Public Structures
    
    struct Parameters {
        let treeId: Tree.ID
        let data: Data
    }
    
    // MARK: Public Properties
    
    var baseURL: URL
    
    var path: String {
        "/api/tree/attachFile/\(params.treeId)"
    }
    
    var method: Method = .post
    
    var sampleData: Data = Data()
    
    var task: Task {
        return .uploadMultipart([.init(provider: .data(params.data),
                                       name: "tree-\(params.treeId)-\(UUID().uuidString)")])
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
