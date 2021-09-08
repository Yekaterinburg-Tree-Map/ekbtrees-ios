//
//  SaveTreeTarget.swift
//  EkbTreeMap
//
//  Created by s.petrov on 28.05.2021.
//

import Moya


final class SaveTreeTarget: AuthorizedTarget {
    
    // MARK: Public Structures
    
    struct Parameters {
        let id: Int?
        let position: TreePosition
        let type: String?
        let height: Double?
        let numberOfTrunks: Int?
        let trunkGirth: Double?
        let diametrOfCrown: Double?
        let heightOfFirstBranch: Double?
        let condition: Int?
        let age: Int?
    }
    
    enum Keys: String {
        case id
        case geographicalPoint
        case latitude
        case longitude
        case type
        case treeHeight
        case numberOfTreeTrunks
        case trunkGirth
        case diameterOfCrown
        case heightOfTheFirstBranch
        case conditionAssessment
        case age
    }
    
    // MARK: Public Properties
    
    var baseURL: URL
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    var path: String = "/api/tree/save"
    
    var method: Method = .post
    
    var sampleData: Data = Data()
    
    var task: Task {
        let position = [Keys.latitude.rawValue: params.position.latitude,
                        Keys.longitude.rawValue: params.position.longitude]
        let parameters: [String: Any?] = [Keys.id.rawValue: params.id,
                                         Keys.geographicalPoint.rawValue: position,
                                         Keys.type.rawValue: params.type,
                                         Keys.treeHeight.rawValue: params.height,
                                         Keys.numberOfTreeTrunks.rawValue: params.numberOfTrunks,
                                         Keys.trunkGirth.rawValue: params.trunkGirth,
                                         Keys.diameterOfCrown.rawValue: params.diametrOfCrown,
                                         Keys.heightOfTheFirstBranch.rawValue: params.heightOfFirstBranch,
                                         Keys.conditionAssessment.rawValue: params.condition,
                                         Keys.age.rawValue: params.age]
		return .requestParameters(parameters: parameters.filter { $1 != nil }.compactMapValues { $0 },
                                  encoding: JSONEncoding.default)
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
