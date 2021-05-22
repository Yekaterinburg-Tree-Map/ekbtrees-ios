//
//  PhotoRemoteDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift


protocol PhotoRemoteDataProviding {
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoRemoteDataProvider: PhotoRemoteDataProviding {
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        Observable.just([]).startWith([])
    }
}
