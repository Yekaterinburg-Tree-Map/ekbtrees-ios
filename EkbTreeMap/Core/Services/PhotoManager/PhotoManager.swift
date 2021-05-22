//
//  PhotoManager.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit
import RxSwift


protocol PhotoManagerDelegate: AnyObject {
    
    func reloadData()
    func openAddPhoto()
    func openPhotoPreview(startingIndex: Int, photos: [PhotoModelProtocol])
}


protocol PhotoManagerProtocol {
    
    var delegate: PhotoManagerDelegate? { get set }
    
    func startPhotoObserving()
    func addPhotos(_ photos: [UIImage])
}


final class PhotoManager: PhotoManagerProtocol,
                          TreeDetailsPhotoContainerDataSource,
                          TreeDetailsPhotoContainerDelegate {
    
    // MARK: Public Properties
    
    var delegate: PhotoManagerDelegate?
    
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let treeId: Tree.ID
    private let dataProvider: PhotoDataProviding
    
    
    // MARK: Private Properties
    
    private var photos: [PhotoModelProtocol] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    
    // MARK: Lifecycle
    
    init(treeId: Tree.ID,
         dataProvider: PhotoDataProviding) {
        self.treeId = treeId
        self.dataProvider = dataProvider
    }
    
    
    // MARK: Public
    
    func startPhotoObserving() {
        observeImageUpdates()
    }
    
    func addPhotos(_ photos: [UIImage]) {
        dataProvider.loadPhotos(photos, for: treeId)
    }
    
    func isAddButtonEnabled() -> Bool {
        true
    }
    
    func numberOfItems() -> Int {
        photos.count
    }
    
    func photoContainer(_ view: TreeDetailsPhotoContainerView, configureView: TreeDetailsPhotoView, at index: Int) {
        
    }
    
    func photoContainerDidTapAdd(_ view: TreeDetailsPhotoContainerView) {
        delegate?.openAddPhoto()
    }
    
    func photoContainer(_ view: TreeDetailsPhotoContainerView, didTapItem index: Int) {
        delegate?.openPhotoPreview(startingIndex: index, photos: photos)
    }
    
    func photoContainer(_ view: TreeDetailsPhotoContainerView, didTapClose index: Int) {
        
    }
    
    
    // MARK: Private
    
    private func observeImageUpdates() {
        dataProvider.fetchPhotos(for: treeId)
            .withUnretained(self)
            .subscribe(onNext: { obj, photos in
                obj.photos = photos
            })
            .disposed(by: bag)
    }
}
