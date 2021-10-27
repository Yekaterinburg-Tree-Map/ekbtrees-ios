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
    
    func fetchAndTrackAllPendingPhotos() -> Observable<[LocalPhotoModel]>
    func fetchAndTrackPhotos(treeId: Tree.ID) -> Observable<[LocalPhotoModel]>
    func addPendingPhotos(_ photos: [UIImage], treeId: Tree.ID)
    func updatePhotoModelStatus(id: String, status: UploadPhotoStatus)
}


final class PhotoLoaderRepository: PhotoLoaderRepositoryProtocol {
    
    // MARK: Private Properties
    
    private let store: Store
    private let mapper: UploadPhotoMapper
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    init(store: Store, mapper: UploadPhotoMapper) {
        self.store = store
        self.mapper = mapper
    }
    
    
    // MARK: Public
    
    func fetchAndTrackAllPendingPhotos() -> Observable<[LocalPhotoModel]> {
        store.fetchAllAndMap(mapper: mapper)
    }
    
    func fetchAndTrackPhotos(treeId: Tree.ID) -> Observable<[LocalPhotoModel]> {
        store.fetchAllAndMap(mapper: mapper)
            .map { photos in
                photos.filter { $0.treeId == treeId }
            }
    }
    
    func addPendingPhotos(_ photos: [UIImage], treeId: Tree.ID) {
        let entities = photos.map { photo -> UploadingPhotoEntity in
            let model = self.setupNewPhoto(photo, treeId: treeId)
            return self.mapper.mapEntity(model)
        }
        store.createOrUpdate(entities: entities)
    }
    
    func updatePhotoModelStatus(id: String, status: UploadPhotoStatus) {
        store.fetchAndNotify(of: UploadingPhotoEntity.self, predicate: "id == '\(id)'")
            .withUnretained(self)
            .subscribe(on: SerialDispatchQueueScheduler.init(qos: .utility))
            .subscribe(onNext: { obj, entity in
                obj.updatePhotoEntity(entity, status: status)
            })
            .disposed(by: bag)
    }
    
    
    // MARK: Private
    
    private func setupNewPhoto(_ photo: UIImage, treeId: Tree.ID) -> LocalPhotoModel {
        return LocalPhotoModel(tempId: UUID().uuidString,
                               treeId: treeId,
                               image: photo,
                               loadStatus: .pending)
    }
    
    private func updatePhotoEntity(_ entity: UploadingPhotoEntity, status: UploadPhotoStatus) {
        var model = mapper.mapModel(entity)
        model.loadStatus = status
        let newEntity = mapper.mapEntity(model)
        store.createOrUpdate(entity: newEntity)
    }
}
