//
//  PhotoRemoteDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift


protocol PhotoRemoteDataProviding {
    
    func deletePhoto(id: Int)
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoRemoteDataProvider: PhotoRemoteDataProviding {
    
    // MARK: Private Properties
    
    private let resolver: IResolver
    private let networkService: NetworkServiceProtocol
    private let treeFilesParser: TreeFilesParser
    
    
    // MARK: Lifecycle
    
    init(resolver: IResolver,
         networkService: NetworkServiceProtocol,
         treeFilesParser: TreeFilesParser) {
        self.resolver = resolver
        self.networkService = networkService
        self.treeFilesParser = treeFilesParser
    }
    
    // MARK: Public
    
    func deletePhoto(id: Int) {
        
    }
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        let parameters = GetPhotosByTreeIdTarget.Parameters(id: treeId)
        let target: GetPhotosByTreeIdTarget = resolver.resolve(arg: parameters)
        
        return networkService.sendRequest(target, parser: treeFilesParser)
            .map { files in
                files.map { $0 as PhotoModelProtocol }
            }
    }
}
