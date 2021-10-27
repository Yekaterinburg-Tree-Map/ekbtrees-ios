//
//  PhotoRemoteDataProvider.swift
//  EkbTreeMap
//
//  Created by s.petrov on 22.05.2021.
//

import RxSwift


protocol PhotoRemoteDataProviding {
    
    func deletePhoto(id: Int) -> Observable<Void>
    func uploadPhotos(_ photos: [UIImage], for treeId: Tree.ID) -> Observable<Void>
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]>
}


final class PhotoRemoteDataProvider: PhotoRemoteDataProviding {
    
    // MARK: Private Properties
    
    private let resolver: IResolver
    private let networkService: NetworkServiceProtocol
    private let photoLoaderService: PhotoLoaderServiceProtocol
    private let treeFilesParser: TreeFilesParser
    
    private var photos: [RemotePhotoModel] = []
    private let photosSubject = BehaviorSubject<[PhotoModelProtocol]>(value: [])
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    init(resolver: IResolver,
         networkService: NetworkServiceProtocol,
         photoLoaderService: PhotoLoaderServiceProtocol,
         treeFilesParser: TreeFilesParser) {
        self.resolver = resolver
        self.networkService = networkService
        self.photoLoaderService = photoLoaderService
        self.treeFilesParser = treeFilesParser
    }
    
    // MARK: Public
    
    func uploadPhotos(_ photos: [UIImage], for treeId: Tree.ID) -> Observable<Void> {
        photoLoaderService.uploadPhotosSync(photos, treeId: treeId)
    }
    
    func deletePhoto(id: Int) -> Observable<Void> {
        let parameters = DeletePhotosByIdTarget.Parameters(id: id)
        let target: DeletePhotosByIdTarget = resolver.resolve(arg: parameters)
        
        return networkService.sendRequestWithEmptyResponse(target)
            .do(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.photos.removeAll(where: { $0.id == id })
                self.photosSubject.onNext(self.photos)
            })
    }
    
    func fetchPhotos(for treeId: Tree.ID) -> Observable<[PhotoModelProtocol]> {
        let parameters = GetPhotosByTreeIdTarget.Parameters(id: treeId)
        let target: GetPhotosByTreeIdTarget = resolver.resolve(arg: parameters)
        networkService.sendRequest(target, parser: treeFilesParser)
            .subscribe(onNext: { [weak self] photos in
                guard let self = self else {
                    return
                }
                self.photos = photos
                self.photosSubject.onNext(self.photos)
            })
            .disposed(by: bag)
        
        return photosSubject
    }
}
