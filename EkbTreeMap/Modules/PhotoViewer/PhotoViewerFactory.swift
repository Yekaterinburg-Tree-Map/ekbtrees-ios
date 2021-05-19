//
//  PhotoViewerFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 18.05.2021.
//

import Lightbox


final class PhotoViewerFactory: Factory {
    
    struct Context {
        let images: [UIImage]
        let startIndex: Int
    }
    
    // MARK: Public
    
    func build(with context: Context) -> UIViewController {
        let lightboxImages = setupImages(context.images)
        let lightboxController = LightboxController(images: lightboxImages, startIndex: context.startIndex)
        return lightboxController
    }
    
    
    // MARK: Private
    
    private func setupImages(_ images: [UIImage]) -> [LightboxImage] {
        images.map { image -> LightboxImage in
            LightboxImage(image: image)
        }
    }
}
