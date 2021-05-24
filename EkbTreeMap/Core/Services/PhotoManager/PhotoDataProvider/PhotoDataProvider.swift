//
//  PhotoDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift
import UIKit


protocol PhotoDataProviding {
    
    func deletePhoto(id: String)
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
    
    func deletePhoto(id: String) {
        remoteDataProvider.deletePhoto(id: id)
    }
    
    func loadPhotos(_ photos: [UIImage], for treeId: Tree.ID) {
        localDataProvider.loadPhotos(photos, for: treeId)
    }
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        Observable.combineLatest(localDataProvider.fetchPhotos(for: treeId).startWith([]),
                                 remoteDataProvider.fetchPhotos(for: treeId).startWith([])) { $0 + $1 }
    }
}
