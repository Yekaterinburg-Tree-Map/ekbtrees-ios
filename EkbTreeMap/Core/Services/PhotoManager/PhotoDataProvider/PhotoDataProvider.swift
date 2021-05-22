//
//  PhotoDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift
import UIKit


protocol PhotoDataProviding {
    
    func loadPhotos(_ photos: [UIImage], for treeId: Tree.ID)
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoDataProvider: PhotoDataProviding {
    
    // MARK: Private Properties
    
    private let localDataProvider: PhotoLocalDataProviding
    private let remoteDataProvider: PhotoRemoteDataProviding
    
    
    
    // MARK: Lifecycle
    
    init(localDataProvider: PhotoLocalDataProviding,
         remoteDataProvider: PhotoRemoteDataProviding) {
        self.localDataProvider = localDataProvider
        self.remoteDataProvider = remoteDataProvider
    }
    
    
    // MARK: Public
    
    func loadPhotos(_ photos: [UIImage], for treeId: Tree.ID) {
        
    }
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        Observable.combineLatest(localDataProvider.fetchPhotos(for: treeId),
                                 remoteDataProvider.fetchPhotos(for: treeId)) { $0 + $1 }
    }
}
