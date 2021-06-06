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
    
    private let resolver: IResolver
    private let networkService: NetworkServiceProtocol
    private let loaderRepository: PhotoLoaderRepositoryProtocol
    private var currentRequests: [String: DisposeBag] = [:]
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    init(resolver: IResolver,
         networkService: NetworkServiceProtocol,
         loaderRepository: PhotoLoaderRepositoryProtocol) {
        self.resolver = resolver
        self.networkService = networkService
        self.loaderRepository = loaderRepository
        observePendingPhotos()
    }
    
    
    // MARK: Public
    
    func uploadPhotos(_ photos: [UIImage], treeId: Tree.ID) {
        loaderRepository.addPendingPhotos(photos, treeId: treeId)
    }
    
    func cancelUpload(id: String) {
        currentRequests[id] = nil
        loaderRepository.updatePhotoModelStatus(id: id, status: .cancelled)
    }
    
    func retryUpload(id: String) {
        loaderRepository.fetchAndTrackAllPendingPhotos()
            .compactMap { $0.first(where: { $0.tempId == id })}
            .withUnretained(self)
            .subscribe(onNext: { obj, model in
                obj.uploadPhoto(model)
            })
            .disposed(by: bag)
    }
    
    
    // MARK: Private
    
    private func observePendingPhotos() {
        loaderRepository.fetchAndTrackAllPendingPhotos()
            .map { photos in
                photos.filter { [.pending].contains($0.loadStatus) }
            }
            .withUnretained(self)
            .subscribe(onNext: { obj, photos in
                obj.uploadPhotos(photos)
            })
            .disposed(by: bag)
    }
    
    private func uploadPhotos(_ photos: [LocalPhotoModel]) {
        for photo in photos {
            uploadPhoto(photo)
        }
    }
    
    private func uploadPhoto(_ photo: LocalPhotoModel) {
        loaderRepository.updatePhotoModelStatus(id: photo.tempId, status: .loading)
        guard let target = configureTarget(photo) else {
            loaderRepository.updatePhotoModelStatus(id: photo.tempId, status: .cancelled)
            return
        }
        let bag = DisposeBag()
        networkService.sendRequestWithEmptyResponse(target)
            .withUnretained(self)
            .subscribe(onNext: { obj, _ in
                obj.didUploadPhoto(photo)
            })
            .disposed(by: bag)
        currentRequests[photo.tempId] = bag
    }
    
    private func configureTarget(_ photo: LocalPhotoModel) -> AttachFileToTreeTarget? {
        guard let data = photo.image.jpegData(compressionQuality: 1) else {
            return nil
        }
        let params = AttachFileToTreeTarget.Parameters(treeId: photo.treeId, data: data)
        let target: AttachFileToTreeTarget = resolver.resolve(arg: params)
        return target
    }
    
    private func didUploadPhoto(_ photo: LocalPhotoModel) {
        loaderRepository.updatePhotoModelStatus(id: photo.tempId, status: .ready)
        currentRequests[photo.tempId] = nil
    }
}
