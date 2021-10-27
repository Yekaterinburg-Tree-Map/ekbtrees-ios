//
//  PhotoLocalDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift


protocol PhotoLocalDataProviding {
    
    func retryUploadPhoto(model: LocalPhotoModel)
    func cancelUploadPhoto(model: LocalPhotoModel)
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoLocalDataProvider: PhotoLocalDataProviding {
    
    // MARK: Private Properties
    
    private let photoLoaderService: PhotoLoaderServiceProtocol
    private let photoLoaderRepository: PhotoLoaderRepositoryProtocol
    
    
    // MARK: Lifecycle
    
    init(photoLoaderService: PhotoLoaderServiceProtocol,
         photoLoaderRepository: PhotoLoaderRepositoryProtocol) {
        self.photoLoaderService = photoLoaderService
        self.photoLoaderRepository = photoLoaderRepository
    }

    
    // MARK: Public
    
    func loadPhotos(_ photos: [UIImage], for treeId: Tree.ID) {
        photoLoaderService.uploadPhotos(photos, treeId: treeId)
    }
    
    func retryUploadPhoto(model: LocalPhotoModel) {
        photoLoaderService.retryUpload(id: model.tempId)
    }
    
    func cancelUploadPhoto(model: LocalPhotoModel) {
        photoLoaderService.cancelUpload(id: model.tempId)
    }
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        photoLoaderRepository.fetchAndTrackPhotos(treeId: treeId)
            .map {
                $0.map { $0 as PhotoModelProtocol }
            }
    }
}
