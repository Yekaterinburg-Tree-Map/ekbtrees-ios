//
//  TreeDetailsInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import RxSwift
import RxRelay


final class TreeDetailsInteractor: TreeDetailsConfigurable {
    
    private typealias PhotoSource = TreeDetailsPhotoContainerDelegate & TreeDetailsPhotoContainerDataSource
    
    // MARK: Private Properties
    
    private let treeId: Tree.ID
    private let formFactory: TreeDetailsFormFactoryProtocol
    private var output: TreeDetailsModuleOutput?
    private let treeService: TreeDataServiceProtocol
    
    private let bag = DisposeBag()
    private var photoManager: PhotoManagerProtocol
    private let titleSubject = BehaviorSubject<String>(value: "Детали")
    private let itemsSubject = PublishSubject<[ViewRepresentableModel]>()
    private let buttonTitleSubject = BehaviorSubject<String>(value: "Редактировать")
    private let isButtonHiddenSubject = BehaviorSubject<Bool>(value: false)
    private lazy var photoSource = BehaviorSubject<PhotoSource>(value: photoManager)
    private let reloadPhotoSubject = PublishSubject<Void>()
    private let mapDataSubject = PublishSubject<TreeDetailsMapView.DisplayData>()
    private let hudSubject = BehaviorRelay<HUDState>(value: .hidden)
    
    
    // MARK: Lifecycle
    
    init(treeId: Tree.ID,
         formFactory: TreeDetailsFormFactoryProtocol,
         photoManager: PhotoManagerProtocol,
         treeService: TreeDataServiceProtocol,
         output: TreeDetailsModuleOutput) {
        self.treeId = treeId
        self.formFactory = formFactory
        self.photoManager = photoManager
        self.treeService = treeService
        self.output = output
        
        photoManager.delegate = self
    }
    
    
    // MARK: Public
    
    func configure(with output: TreeDetailsView.Output) -> TreeDetailsView.Input {
        bag.insert {
            output.didLoad
                .subscribe(onNext: { [weak self] in self?.didLoad() })
            
            output.willAppear
                .skip(1)
                .subscribe(onNext: { [weak self] in self?.willAppear() })
            
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
                                     reloadPhotos: reloadPhotoSubject,
                                     hudState: hudSubject.asObservable())
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        output?.moduleDidLoad(input: self)
        loadDetails()
    }
    
    private func willAppear() {
        loadDetails()
    }
    
    private func loadDetails() {
        hudSubject.accept(.loading)
        treeService.fetchTree(by: treeId)
            .withUnretained(self)
            .subscribe(onNext: { obj, tree in
                obj.didLoadDetails(tree)
            }, onError: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: bag)
    }
    
    private func didLoadDetails(_ tree: Tree) {
        setupPhotos()
        let items = formFactory.setupFields(tree: tree)
        itemsSubject.onNext(items)
        mapDataSubject.onNext(.init(treePoint: .init(latitude: tree.latitude, longitude: tree.longitude)))
        
        hudSubject.accept(.success(duration: 1.0, completion: { [weak self] in
            self?.hudSubject.accept(.hidden)
        }))
    }
    
    private func showError(_ error: Error) {
        let completion: () -> () = { [weak self] in
            guard let self = self else {
                return
            }
            let alert = self.setupNetworkAlert()
            self.hudSubject.accept(.hidden)
            self.output?.moduleWantsToShowAlert(input: self, alert: alert)
        }
        hudSubject.accept(.failure(duration: 1.0, completion: completion))
    }
    
    private func setupNetworkAlert() -> Alert {
        var alert = Alert(message: "Произошла ошибка")
        
        let cancelHandler: () -> () = { [weak self] in
            guard let self = self else {
                return
            }
            self.output?.moduleWantsToClose(input: self)
        }
        let cancelAction = AlertAction(title: "Отменить",
                                       style: .cancel,
                                       handler: cancelHandler)
        
        let retryHandler: () -> () = { [weak self] in
            self?.loadDetails()
        }
        let retryAction = AlertAction(title: "Перезагрузить",
                                      style: .default,
                                      handler: retryHandler)
        alert.actions = [cancelAction, retryAction]
        return alert
    }
    
    private func setupPhotos() {
        photoManager.startPhotoObserving(treeId: treeId)
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
