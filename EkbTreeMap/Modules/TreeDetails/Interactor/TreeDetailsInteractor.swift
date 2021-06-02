//
//  TreeDetailsInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import RxSwift


final class TreeDetailsInteractor: TreeDetailsConfigurable {
    
    private typealias PhotoSource = TreeDetailsPhotoContainerDelegate & TreeDetailsPhotoContainerDataSource
    
    // MARK: Private Properties
    
    private let tree: Tree
    private let formFactory: TreeDetailsFormFactoryProtocol
    private var output: TreeDetailsModuleOutput?
    
    private let bag = DisposeBag()
    private var photoManager: PhotoManagerProtocol
    private let titleSubject = BehaviorSubject<String>(value: "Детали")
    private let itemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private let buttonTitleSubject = BehaviorSubject<String>(value: "Редактировать")
    private let isButtonHiddenSubject = BehaviorSubject<Bool>(value: false)
    private lazy var photoSource = BehaviorSubject<PhotoSource>(value: photoManager)
    private let reloadPhotoSubject = PublishSubject<Void>()
    private let mapDataSubject = PublishSubject<TreeDetailsMapView.DisplayData>()
    
    
    // MARK: Lifecycle
    
    init(tree: Tree,
         formFactory: TreeDetailsFormFactoryProtocol,
         photoManager: PhotoManagerProtocol,
         output: TreeDetailsModuleOutput) {
        self.tree = tree
        self.formFactory = formFactory
        self.photoManager = photoManager
        self.output = output
        
        photoManager.delegate = self
    }
    
    
    // MARK: Public
    
    func configure(with output: TreeDetailsView.Output) -> TreeDetailsView.Input {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.didTapAction
                .subscribe(onNext: { [weak self] in self?.didTapAction() })
            
            output.didTapClose
                .subscribe(onNext: { [weak self] in self?.didTapClose() })
        }
        return TreeDetailsView.Input(title: titleSubject,
                                     items: itemsSubject,
                                     buttonTitle: buttonTitleSubject,
                                     isButtonHidden: isButtonHiddenSubject,
                                     mapData: mapDataSubject,
                                     photosSource: photoSource,
                                     reloadPhotos: reloadPhotoSubject)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        let items = formFactory.setupFields(tree: tree)
        itemsSubject.onNext(items)
        setupPhotos()
        mapDataSubject.onNext(.init(treePoint: .init(latitude: tree.latitude, longitude: tree.longitude)))
        output?.moduleDidLoad(input: self)
    }
    
    private func setupPhotos() {
        photoManager.startPhotoObserving(treeId: tree.id)
    }
    
    private func didTapAction() {
        output?.moduleWantsToChangeDetails(input: self)
    }
    
    private func didTapClose() {
        output?.moduleWantsToClose(input: self)
    }
}


// MARK: - TreeDetailsModuleInput

extension TreeDetailsInteractor: TreeDetailsModuleInput {
    
    func addPhotos(_ photos: [UIImage]) {
        photoManager.addPhotos(photos)
    }
}


// MARK: - TreeDetailsPhotoManagerDelegate

extension TreeDetailsInteractor: PhotoManagerDelegate {
    
    func openPhotoPreview(startingIndex: Int, photos: [PhotoModelProtocol]) {
        output?.moduleWantToShowPreview(input: self, startingIndex: startingIndex, photos: photos)
    }
    
    func reloadData() {
        reloadPhotoSubject.onNext(())
    }
    
    func openAddPhoto() {
        output?.moduleWantsToAddPhotos(input: self)
    }
}
