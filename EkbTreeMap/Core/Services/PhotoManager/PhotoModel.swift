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


enum UploadPhotoStatus: String {
    
    case loading
    case cancelled
    case ready
    case pending
}


struct LocalPhotoModel: PhotoModelProtocol {

    var tempId: String
    var treeId: Int
    var image: UIImage
    var loadStatus: UploadPhotoStatus
}


struct RemotePhotoModel: PhotoModelProtocol {
    
    let id: Int
    let url: URL
}
