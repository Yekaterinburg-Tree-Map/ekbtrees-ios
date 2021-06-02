//
//  PhotoViewerFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 18.05.2021.
//

import Lightbox


final class PhotoViewerFactory: Factory {
    
    struct Context {
        let images: [PhotoModelProtocol]
        let startIndex: Int
    }
    
    // MARK: Public
    
    func build(with context: Context) -> UIViewController {
        let lightboxImages = setupImages(context.images)
        let lightboxController = LightboxController(images: lightboxImages, startIndex: context.startIndex)
        return lightboxController
    }
    
    
    // MARK: Private
    
    private func setupImages(_ images: [PhotoModelProtocol]) -> [LightboxImage] {
        images.compactMap { image -> LightboxImage? in
            if let model = image as? LocalPhotoModel {
                return LightboxImage(image: model.image)
            }
            
            if let model = image as? RemotePhotoModel {
                return LightboxImage(imageURL: model.url)
            }
            
            return nil
        }
    }
}
