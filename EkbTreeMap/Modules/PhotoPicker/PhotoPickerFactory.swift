//
//  PhotoPickerFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 17.05.2021.
//

import YPImagePicker


protocol PhotoPickerOutput: AnyObject {
    
    func didSelectPhotos(photos: [UIImage])
}


final class PhotoPickerFactory: Factory {
    
    private let configuration: YPImagePickerConfiguration
    init(configuration: YPImagePickerConfiguration) {
        self.configuration = configuration
    }
    
    func build(with output: PhotoPickerOutput) -> UIViewController {
        let vc = YPImagePicker(configuration: configuration)
        vc.didFinishPicking(completion: { [weak output] items, _ in
            let images = items.compactMap { item -> UIImage? in
                switch item {
                case .photo(let photo):
                    return photo.originalImage
                case .video:
                    return nil
                }
            }
            output?.didSelectPhotos(photos: images)
        })
        return vc
    }
}
