//
//  PhotoModel.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import UIKit
import RxSwift


protocol PhotoModelProtocol {
    
}


struct LocalPhotoModel: PhotoModelProtocol {
    
    struct LoadStatus {
        
        let cancelAction: () -> ()
        let progressStatus: Observable<CGFloat>
    }
    
    let tempId: String
    let image: UIImage
    let loadStatus: LoadStatus?
}


struct RemotePhotoModel: PhotoModelProtocol {
    
    let id: String
    let url: URL
}
