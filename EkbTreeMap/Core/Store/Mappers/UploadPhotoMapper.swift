//
//  UploadPhotoMapper.swift
//  EkbTreeMap
//
//  Created by s.petrov on 05.06.2021.
//

import UIKit


final class UploadPhotoMapper: Mapper {
    
    func mapModel(_ entity: UploadingPhotoEntity) -> LocalPhotoModel {
        let image = UIImage(data: entity.data)!
        let loadStatus = UploadPhotoStatus(rawValue: entity.uploadStatus) ?? .cancelled
        return LocalPhotoModel(tempId: entity.id,
                               treeId: entity.treeId,
                               image: image,
                               loadStatus: loadStatus)
    }
    
    func mapEntity(_ model: LocalPhotoModel) -> UploadingPhotoEntity {
        let entity = UploadingPhotoEntity()
        entity.id = model.tempId
        entity.treeId = model.treeId
        entity.uploadStatus = model.loadStatus.rawValue
        entity.data = model.image.jpegData(compressionQuality: 0.7)!
        return entity
    }
}
