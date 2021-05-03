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
    
    // MARK: Frame
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInset = .init(top: 0, left: 0, bottom: 64, right: 0)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var stackView: ViewRepresentableStackView = {
        let view = ViewRepresentableStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private lazy var editButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.layer.cornerRadius = 16
        return button
    }()
    
    
    // MARK: Private Properties
    
    private var interactor: AnyInteractor<TreeDetailsViewOutput, TreeDetailsViewInput>!
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    private let didTapCloseSubject = PublishSubject<Void>()
    
    
    // MARK: Lifecycle
    
    class func instantiate(with interactor: AnyInteractor<TreeDetailsViewOutput,
                                                          TreeDetailsViewInput>) -> TreeDetailsViewController {
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

    
    // MARK: Private
    
    private func setupView() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть",
                                                                                 style: .plain,
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
            $0.left.right.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupIO() {
        let output = TreeDetailsViewOutput(didLoad: didLoadSubject,
                                           didTapAction: editButton.rx.tap.asObservable(),
                                           didTapClose: didTapCloseSubject)
        let input = interactor.configureIO(with: output)
        
        input?.items
            .bind(to: stackView.rx.items)
            .disposed(by: bag)
        
        input?.buttonTitle
            .bind(to: editButton.rx.title(for: .normal))
            .disposed(by: bag)
        
        input?.isButtonHidden
            .bind(to: editButton.rx.isHidden)
            .disposed(by: bag)
        
        input?.title
            .bind(to: rx.title)
            .disposed(by: bag)
    }

}
