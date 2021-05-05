//
//  MapObserverViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import UIKit
import RxSwift
import RxCocoa


final class MapObserverViewController: UIViewController {
    
    // MARK: Frame
    
    private lazy var containerView: UIView = UIView()
    private lazy var addButton = CircleImagedButton(frame: .zero)
    private lazy var annotationView: TreeAnnotationView = {
        let view = TreeAnnotationView(frame: .zero)
        view.alpha = 0
        return view
    }()
    
    
    // MARK: Private Properties
    
    private var interactor: MapObserverViewConfigurable!
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    private let didTapAddSubject = PublishSubject<Void>()
    
    
    // MARK: Lifecycle
    
    class func instantiate(with interactor: MapObserverViewConfigurable) -> MapObserverViewController {
        let vc = MapObserverViewController()
        vc.interactor = interactor
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureIO()
        setupConstraints()
        
        didLoadSubject.onNext(())
    }
    
    
    // MARK: Private
    
    private func configureIO() {
        let output = MapObserverView.Output(didLoad: didLoadSubject,
                                            didTapMoreButton: annotationView.rx.tap.asObservable(),
                                            didTapAdd: addButton.rx.tap.asObservable())
        let input = interactor.configure(with: output)
        
        bag.insert {
            input.annotationView
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: annotationView.rx.configuration)
            
            input.addButtonImage
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: addButton.rx.icon)
            
            input.embedVCFromFactory
                .observe(on: MainScheduler.asyncInstance)
                .withUnretained(self)
                .subscribe(onNext: { obj, factory in
                    let vc = factory()
                    obj.embedViewController(vc, to: obj.containerView)
                })
        }
    }
    
    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(annotationView)
        annotationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaInsets).inset(64)
        }
    }
}
