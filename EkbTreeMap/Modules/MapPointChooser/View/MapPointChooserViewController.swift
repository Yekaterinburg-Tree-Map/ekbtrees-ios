//
//  MapPointChooserViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import UIKit
import RxSwift
import RxCocoa


class MapPointChooserViewController: UIViewController {
    
    // MARK: Frame
    
    private lazy var containerView = UIView()
    private lazy var circleButton = CircleImagedButton(frame: .zero)
    private lazy var placemarkImageView = UIImageView(image: UIImage(named: "placemark"))
    
    // MARK: Private Properties
    
    private var interactor: MapPointChooserConfigurable!
    
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    private let didTapCloseSubject = PublishSubject<Void>()
    
    // MARK: Lifecycle
    
    class func instantiate(_ interactor: MapPointChooserConfigurable) -> MapPointChooserViewController {
        let vc = MapPointChooserViewController()
        vc.interactor = interactor
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выбор позиции"
        setupConstraints()
        configureIO()
        setupNavigationBar()
        
        didLoadSubject.onNext(())
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapClose))
    }
    
    @objc
    private func didTapClose() {
        didTapCloseSubject.onNext(())
    }
    
    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(circleButton)
        circleButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaInsets).inset(64)
        }
        
        view.addSubview(placemarkImageView)
        placemarkImageView.clipsToBounds = true
        placemarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(32)
        }
    }
    
    private func configureIO() {
        let output = MapPointChooserView.Output(didLoad: didLoadSubject,
                                                didTapDone: circleButton.rx.tap.asObservable(),
                                                didTapClose: didTapCloseSubject)
        
        let input = interactor.configure(with: output)
        
        bag.insert {
            input.title
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: rx.title)
            
            input.mapFactory
                .observe(on: MainScheduler.asyncInstance)
                .withUnretained(self)
                .subscribe(onNext: { obj, factory in
                    let vc = factory()
                    obj.embedViewController(vc, to: obj.containerView)
                })
            
            input.doneButtonImage
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: circleButton.rx.icon)
        }
    }
}
