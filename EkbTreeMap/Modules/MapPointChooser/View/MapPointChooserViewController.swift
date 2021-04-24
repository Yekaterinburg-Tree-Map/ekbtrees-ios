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
    
    private var interactor: AnyInteractor<MapPointChooserViewOutput, MapPointChooserViewInput>!
    
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    
    // MARK: Lifecycle
    
    class func instantiate(_ interactor: AnyInteractor<MapPointChooserViewOutput,
                                                       MapPointChooserViewInput>) -> MapPointChooserViewController {
        let vc = MapPointChooserViewController()
        vc.interactor = interactor
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureIO()
        
        didLoadSubject.onNext(())
    }
    
    
    // MARK: Private
    
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
        let output = MapPointChooserViewOutput(didLoad: didLoadSubject)
        
        let input = interactor.configureIO(with: output)
        
        input?.mapFactory
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { obj, factory in
                let vc = factory()
                obj.embedViewController(vc, to: obj.containerView)
            })
            .disposed(by: bag)
        
        input?.doneButtonImage
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: circleButton.rx.icon)
            .disposed(by: bag)
    }
}
