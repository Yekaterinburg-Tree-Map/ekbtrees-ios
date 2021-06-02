//
//  TreeDetailsViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit
import RxSwift
import RxCocoa


final class TreeDetailsViewController: UIViewController {
    
    private typealias PhotoSource = TreeDetailsPhotoContainerDataSource & TreeDetailsPhotoContainerDelegate
    
    // MARK: Frame
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var mapView: TreeDetailsMapView = TreeDetailsMapView(frame: .zero)
    private lazy var photoCollectionView = TreeDetailsPhotoContainerView(frame: .zero)
    private lazy var detailsStackView: ViewRepresentableStackView = {
        let view = ViewRepresentableStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private lazy var gradientContainer = GradientContainer()
    
    private lazy var editButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.layer.cornerRadius = 16
        return button
    }()
    
    
    // MARK: Private Properties
    
    private var interactor: TreeDetailsConfigurable!
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    private let willAppearSubject = PublishSubject<Void>()
    private let didTapCloseSubject = PublishSubject<Void>()
        
    
    // MARK: Lifecycle
    
    class func instantiate(with interactor: TreeDetailsConfigurable) -> TreeDetailsViewController {
        let vc = TreeDetailsViewController()
        vc.interactor = interactor
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupView()
        setupIO()
        
        didLoadSubject.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        willAppearSubject.onNext(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            gradientContainer.setupGradient(colors: [UIColor.systemBackground.withAlphaComponent(0).cgColor,
                                                     UIColor.systemBackground.cgColor])
        } else {
            gradientContainer.setupGradient(colors: [UIColor.white.withAlphaComponent(0).cgColor,
                                                     UIColor.white.cgColor])
        }
    }

    
    // MARK: Private
    
    private func setupView() {
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(photoCollectionView)
        stackView.addArrangedSubview(detailsStackView)
    
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
            gradientContainer.setupGradient(colors: [UIColor.systemBackground.withAlphaComponent(0).cgColor,
                                                     UIColor.systemBackground.cgColor])
        } else {
            view.backgroundColor = .white
            gradientContainer.setupGradient(colors: [UIColor.white.withAlphaComponent(0).cgColor,
                                                     UIColor.white.cgColor])
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapClose))
    }
    
    @objc
    private func didTapClose() {
        didTapCloseSubject.onNext(())
    }
    
    private func setupConstraint() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalTo(view)
        }
        
        view.addSubview(gradientContainer)
        gradientContainer.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        gradientContainer.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    
    private func setupIO() {
        let output = TreeDetailsView.Output(didLoad: didLoadSubject,
                                            willAppear: willAppearSubject,
                                            didTapAction: editButton.rx.tap.asObservable(),
                                            didTapClose: didTapCloseSubject)
        let input = interactor.configure(with: output)
        
        bag.insert {
            input.items
                .bind(to: detailsStackView.rx.items)
            
            input.buttonTitle
                .bind(to: editButton.rx.title(for: .normal))
            
            input.isButtonHidden
                .bind(to: editButton.rx.isHidden)
            
            input.title
                .bind(to: rx.title)
            
            input.mapData
                .withUnretained(self)
                .subscribe(onNext: { obj, data in
                    obj.mapView.configure(with: data)
                })
            
            input.photosSource
                .withUnretained(self)
                .subscribe(onNext: { obj, source in
                    obj.photoCollectionView.delegate = source
                    obj.photoCollectionView.dataSource = source
                    obj.photoCollectionView.reloadData()
                })
            
            input.reloadPhotos
                .withUnretained(self)
                .subscribe(onNext: { obj, _ in
                    obj.photoCollectionView.reloadData()
                })
            
            input.hudState.withUnretained(self)
                .subscribe(onNext: { obj, state in
                    obj.updateHUDState(state)
                })
        }
    }
}
