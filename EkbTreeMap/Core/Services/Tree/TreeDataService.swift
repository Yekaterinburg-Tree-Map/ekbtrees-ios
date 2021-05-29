//
//  TreeDataService.swift
//  EkbTreeMap
//
//  Created by s.petrov on 28.05.2021.
//

import RxSwift


protocol TreeDataServiceProtocol {
    
    func saveTree(_ data: TreeEditorPendingData) -> Observable<Void>
}


final class TreeDataService: TreeDataServiceProtocol {
    
    // MARK: Private Properties
    
    private let resolver: IResolver
    private let networkService: NetworkServiceProtocol
    
    
    // MARK: Lifecycle
    
    init(resolver: IResolver, networkService: NetworkServiceProtocol) {
        self.resolver = resolver
        self.networkService = networkService
    }
    
    
    // MARK: Public
    
    func saveTree(_ data: TreeEditorPendingData) -> Observable<Void> {
        let parameters = SaveTreeTarget.Parameters(id: data.id,
                                                   position: .init(latitude: data.latitude, longitude: data.longitude),
                                                   type: data.type,
                                                   height: data.treeHeight,
                                                   numberOfTrunks: data.numberOfTreeTrunks,
                                                   trunkGirth: data.trunkGirth,
                                                   diametrOfCrown: data.diameterOfCrown,
                                                   heightOfFirstBranch: data.heightOfTheFirstBranch,
                                                   condition: data.conditionAssessment,
                                                   age: data.age)
        let target: SaveTreeTarget = resolver.resolve(arg: parameters)
        return networkService.sendRequestWithEmptyResponse(target)
    }
}
