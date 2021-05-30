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
    
    enum LoadStatus {
        
        case loading
        case cancelled
        case ready
    }
    
    var tempId: String
    var image: UIImage
    var loadStatus: LoadStatus
}


struct RemotePhotoModel: PhotoModelProtocol {
    
    let id: Int
    let url: URL
}
