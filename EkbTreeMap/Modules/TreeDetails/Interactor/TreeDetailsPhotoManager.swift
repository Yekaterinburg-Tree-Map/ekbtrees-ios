//
//  TreeDetailsPhotoManager.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit


protocol TreeDetailsPhotoManagerDelegate: AnyObject {
    
    func openAddPhoto()
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
        var images: [ViewRepresentableModel] = []
        if isEditAvailable {
            let add = setupAddPhotoView()
            images.insert(add, at: 0)
        }
        return images
    }
    
    
    // MARK: Private
    
    private func setupAddPhotoView() -> ViewRepresentableModel {
        let data = TreeDetailsAddPhotoView.DisplayData(action: { [weak delegate] in
            delegate?.openAddPhoto()
        })
        return GenericViewModel<TreeDetailsAddPhotoView>(data: data)
    }
}
