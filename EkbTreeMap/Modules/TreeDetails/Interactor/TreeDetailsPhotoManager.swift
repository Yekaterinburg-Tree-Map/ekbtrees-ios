//
//  TreeDetailsPhotoManager.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit


protocol TreeDetailsPhotoManagerDelegate: AnyObject {
    
    func openAddPhoto()
    func openPhotoPreview(startingIndex: Int, photos: [UIImage])
}


protocol TreeDetailsPhotoManagerProtocol {
    
    var delegate: TreeDetailsPhotoManagerDelegate? { get set }
    
    func addPhotos(_ photos: [UIImage])
    func prepareImages(isEditAvailable: Bool) -> [ViewRepresentableModel]
}


final class TreeDetailsPhotoManager: TreeDetailsPhotoManagerProtocol {
    
    // MARK: Public Properties
    
    var delegate: TreeDetailsPhotoManagerDelegate?
    
    
    // MARK: Private Properties
    
    private var photos: [UIImage] = []
    
    
    // MARK: Public
    
    func addPhotos(_ photos: [UIImage]) {
        self.photos.append(contentsOf: photos)
    }
    
    func prepareImages(isEditAvailable: Bool) -> [ViewRepresentableModel] {
        var images: [ViewRepresentableModel] = setupPhotos()
        if isEditAvailable {
            let add = setupAddPhotoView()
            images.insert(add, at: 0)
        }
        return images
    }
    
    
    // MARK: Private
    
    private func setupPhotos() -> [ViewRepresentableModel] {
        var models: [ViewRepresentableModel] = []
        for (index, photo) in photos.enumerated() {
            let action: () -> () = { [weak self] in
                guard let self = self else {
                    return
                }
                self.delegate?.openPhotoPreview(startingIndex: index, photos: self.photos)
            }
            let data = TreeDetailsPhotoView.DisplayData(image: photo, action: action)
            let model = GenericViewModel<TreeDetailsPhotoView>(data: data)
            models.append(model)
        }
        return models
    }
    
    private func setupAddPhotoView() -> ViewRepresentableModel {
        let data = TreeDetailsAddPhotoView.DisplayData(action: { [weak delegate] in
            delegate?.openAddPhoto()
        })
        return GenericViewModel<TreeDetailsAddPhotoView>(data: data)
    }
}
