//
//  PhotoLoaderService.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.05.2021.
//

import RxSwift


protocol PhotoLoaderServiceProtocol {
    
    func uploadPhotos(_ photos: [UIImage], treeId: Tree.ID)
    func cancelUpload(id: String)
    func retryUpload(id: String)
}


final class PhotoLoaderService: PhotoLoaderServiceProtocol {
    
    // MARK: Private Properties
    
    private let loaderRepository: PhotoLoaderRepositoryProtocol
    
    
    // MARK: Lifecycle
    
    init(loaderRepository: PhotoLoaderRepositoryProtocol) {
        self.loaderRepository = loaderRepository
    }
    
    // MARK: Public
    
    func uploadPhotos(_ photos: [UIImage], treeId: Tree.ID) {
        let ids = loaderRepository.addPendingPhotos(photos, treeId: treeId)
        for id in ids {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.loaderRepository.updatePhotoModelStatus(id: id, status: .ready)
            }
        }
    }
    
    func cancelUpload(id: String) {
        // network cancel
        loaderRepository.updatePhotoModelStatus(id: id, status: .cancelled)
    }
    
    func retryUpload(id: String) {
        // network retry
        loaderRepository.updatePhotoModelStatus(id: id, status: .loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loaderRepository.updatePhotoModelStatus(id: id, status: .ready)
        }
    }
}
