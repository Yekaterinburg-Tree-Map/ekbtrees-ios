//
//  PhotoLoaderRepository.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.05.2021.
//

import UIKit
import RxSwift
import RxRelay


protocol PhotoLoaderRepositoryProtocol {
    
    func fetchAndTrackPendingPhotos(treeId: Tree.ID) -> Observable<[LocalPhotoModel]>
    func fetchPendingPhotos(treeId: Tree.ID) -> [LocalPhotoModel]
    func addPendingPhotos(_ photos: [UIImage], treeId: Tree.ID) -> [String]
    func updatePhotoModelStatus(id: String, status: LocalPhotoModel.LoadStatus)
}


final class PhotoLoaderRepository: PhotoLoaderRepositoryProtocol {
    
    private var photosSubject = BehaviorRelay<[LocalPhotoModel]>(value: [])
    
    func fetchAndTrackPendingPhotos(treeId: Tree.ID) -> Observable<[LocalPhotoModel]> {
        photosSubject.asObservable()
    }
    
    func fetchPendingPhotos(treeId: Tree.ID) -> [LocalPhotoModel] {
        photosSubject.value
    }
    
    func addPendingPhotos(_ photos: [UIImage], treeId: Tree.ID) -> [String] {
        let current = photosSubject.value
        let new = photos.map(setupNewPhoto)
        photosSubject.accept(current + new)
        return new.map(\.tempId)
    }
    
    func updatePhotoModelStatus(id: String, status: LocalPhotoModel.LoadStatus) {
        var tempArray = photosSubject.value
        guard var existingModel = tempArray.first(where: { $0.tempId == id }) else {
            return
        }
        existingModel.loadStatus = status
        tempArray.removeAll(where: { $0.tempId == existingModel.tempId })
        photosSubject.accept(tempArray + [existingModel])
    }
    
    
    // MARK: Private
    
    private func setupNewPhoto(_ photos: UIImage) -> LocalPhotoModel {
        return LocalPhotoModel(tempId: UUID().uuidString,
                               image: photos,
                               loadStatus: .loading)
    }
}
