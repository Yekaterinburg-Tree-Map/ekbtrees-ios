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
    
    private let networkService: NetworkServiceProtocol
    private let loaderRepository: PhotoLoaderRepositoryProtocol
    private var currentRequests: [String: Disposable] = [:]
    
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol,
         loaderRepository: PhotoLoaderRepositoryProtocol) {
        self.networkService = networkService
        self.loaderRepository = loaderRepository
        observePendingPhotos()
    }
    
    
    // MARK: Public
    
    func uploadPhotos(_ photos: [UIImage], treeId: Tree.ID) {
        loaderRepository.addPendingPhotos(photos, treeId: treeId)
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
    
    
    // MARK: Private
    
    private func observePendingPhotos() {
        
    }
}
