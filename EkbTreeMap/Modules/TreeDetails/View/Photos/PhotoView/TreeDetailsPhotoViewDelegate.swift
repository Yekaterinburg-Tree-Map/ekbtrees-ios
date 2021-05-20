//
//  TreeDetailsPhotoViewDelegate.swift
//  EkbTreeMap
//
//  Created by s.petrov on 20.05.2021.
//

import Foundation


enum TreeDetailsPhotoViewType {
    
    case add
    case photo
}


protocol TreeDetailsPhotoViewDelegate: AnyObject {
    
    func photoViewDidTriggerAction(_ view: TreeDetailsBasePhotoView, type: TreeDetailsPhotoViewType)
    func photoViewDidTriggerClose(_ view: TreeDetailsBasePhotoView, type: TreeDetailsPhotoViewType)
}
