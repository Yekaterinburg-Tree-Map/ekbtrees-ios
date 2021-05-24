//
//  PhotoLocalDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift


protocol PhotoLocalDataProviding {
    
    func loadPhotos(_ photos: [UIImage], for treeId: Tree.ID)
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoLocalDataProvider: PhotoLocalDataProviding {
    
    
    let localPhotos = BehaviorSubject<[PhotoModelProtocol]>(value: [LocalPhotoModel]())
    
    // MARK: Public
    
    func loadPhotos(_ photos: [UIImage], for treeId: Tree.ID) {
        do {
            let current = try localPhotos.value()
            let result = current + photos.map { LocalPhotoModel(tempId: "", image: $0, loadStatus: nil) }
            localPhotos.onNext(result)
        } catch {
            
        }
    }
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        localPhotos
    }
}
