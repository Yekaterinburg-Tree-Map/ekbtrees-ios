//
//  TreeEditorViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import UIKit
import RxSwift
import RxCocoa


final class TreeEditorViewController: UIViewController {
    
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var gradientContainer = GradientContainer()
    
    
    // MARK: Private Properties
    
    private var interactor: TreeEditorConfigurable!
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    
    
    // MARK: Lifecycle
    
    class func instantiate(with interactor: TreeEditorConfigurable) -> TreeEditorViewController {
        let vc = TreeEditorViewController()
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
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    private func setupConstraint() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        
        view.addSubview(gradientContainer)
        gradientContainer.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        gradientContainer.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    
    private func setupIO() {
        let output = TreeEditorView.Output(didLoad: didLoadSubject,
                                           didTapSave: addButton.rx.tap.asObservable())
        let input = interactor.configure(with: output)
        
        bag.insert {
            input.formItems
                .bind(to: stackView.rx.items)
            
            input.saveButtonTitle
                .bind(to: addButton.rx.title(for: .normal))
            
            input.title
                .bind(to: rx.title)
        }
    }
}
