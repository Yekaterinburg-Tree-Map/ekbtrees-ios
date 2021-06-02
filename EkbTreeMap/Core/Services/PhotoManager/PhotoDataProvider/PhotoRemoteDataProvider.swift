//
//  PhotoRemoteDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift


protocol PhotoRemoteDataProviding {
    
    func deletePhoto(id: String)
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoRemoteDataProvider: PhotoRemoteDataProviding {
    
    func deletePhoto(id: String) {
        
    }
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        let subject = PublishSubject<[PhotoModelProtocol]>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            subject.onNext([RemotePhotoModel.init(id: "", url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/440px-Image_created_with_a_mobile_phone.png")!)])
        }
        
        return subject
    }
}
