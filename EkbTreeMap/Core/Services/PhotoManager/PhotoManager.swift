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
    func didFailToDelete(error: Error)
}


protocol PhotoManagerProtocol: TreeDetailsPhotoContainerDataSource, TreeDetailsPhotoContainerDelegate {
    
    var delegate: PhotoManagerDelegate? { get set }
    
    func startPhotoObserving(treeId: Tree.ID)
    func addPhotos(_ photos: [UIImage])
}


final class PhotoManager: PhotoManagerProtocol {
    
    // MARK: Public Properties
    
    var delegate: PhotoManagerDelegate?
    
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private var treeId: Tree.ID = 0
    private let dataProvider: PhotoDataProviding
    
    
    // MARK: Private Properties
    
    private var photos: [PhotoModelProtocol] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    
    // MARK: Lifecycle
    
    init(dataProvider: PhotoDataProviding) {
        self.dataProvider = dataProvider
    }
    
    // MARK: Public
    
    func startPhotoObserving(treeId: Tree.ID) {
        self.treeId = treeId
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
        guard index < photos.count else {
            return
        }
        
        let model = photos[index]
        configureView.configure(with: model)
    }
    
    func photoContainerDidTapAdd(_ view: TreeDetailsPhotoContainerView) {
        delegate?.openAddPhoto()
    }
    
    func photoContainer(_ view: TreeDetailsPhotoContainerView, didTapItem index: Int) {
        guard index < photos.count, index >= 0 else {
            return
        }
        if let model = photos[index] as? LocalPhotoModel {
            switch model.loadStatus {
            case .cancelled:
                dataProvider.retryUploadPhoto(model: model)
            case .loading:
                dataProvider.cancelUploadPhoto(model: model)
            case .ready:
                delegate?.openPhotoPreview(startingIndex: index, photos: photos)
            }
        } else {
            delegate?.openPhotoPreview(startingIndex: index, photos: photos)
        }
    }
    
    func photoContainer(_ view: TreeDetailsPhotoContainerView, didTapClose index: Int) {
        guard index < photos.count, let model = photos[index] as? RemotePhotoModel else {
            return
        }
        
        dataProvider.deletePhoto(id: model.id)
            .subscribe(onError: { [weak self] error in
                self?.delegate?.didFailToDelete(error: error)
            })
            .disposed(by: bag)
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
