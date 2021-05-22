//
//  PhotoLocalDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift


protocol PhotoLocalDataProviding {
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoLocalDataProvider: PhotoLocalDataProviding {
    
    
    
    // MARK: Public
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        .never()
    }
}
