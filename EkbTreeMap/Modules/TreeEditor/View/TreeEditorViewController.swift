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
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    
    private lazy var stackView: ViewRepresentableStackView = {
        let view = ViewRepresentableStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private lazy var addButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.systemGreen
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.layer.cornerRadius = 16
        return button
    }()
    
    
    // MARK: Private Properties
    
    private var interactor: AnyInteractor<TreeEditorViewOutput, TreeEditorViewInput>!
    
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    
    
    // MARK: Lifecycle
    
    class func instantiate(with interactor: AnyInteractor<TreeEditorViewOutput,
                                                          TreeEditorViewInput>) -> TreeEditorViewController {
        let vc = TreeEditorViewController()
        vc.interactor = interactor
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Детали"
        setupConstraint()
        setupIO()
        fillStackView()
        
        
        didLoadSubject.onNext(())
    }
    
    
    // MARK: Public
    
    func fillStackView() {
        let model = GenericViewModel<TreeEditorStepperCell>(data: .init(title: "Stepper", value: 2))
        let view = model.setupView()
        stackView.addArrangedSubview(view)
        
//        let stepper = TreeEditorStepperCell(frame: .zero)
//        stepper.configure(with: .init(title: "Stepper", value: nil))
//        stackView.addArrangedSubview(stepper)
//
//        let data = TreeEditorDataCell(frame: .zero)
//        data.configure(title: "Longitude", subtitle: "62.04213")
//        stackView.addArrangedSubview(data)
//
//        let enter = TreeEditorEnterDataCell(frame: .zero)
//        enter.configure(title: "Enter data", subtitle: nil)
//        stackView.addArrangedSubview(enter)
//
//        let picker = TreeEditorPickerCell(frame: .zero)
//        stackView.addArrangedSubview(picker)
//
//        let stepper2 = TreeEditorStepperCell.instantiate()
//        stepper2.configure(title: "Stepper", subtitle: nil)
//        stackView.addArrangedSubview(stepper2)

    }

    
    // MARK: Private
    
    private func updateFormItems(_ items: [ViewRepresentableModel]) {
        stackView.updateItems(items)
    }
    
    private func setupConstraint() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupIO() {
        let output = TreeEditorViewOutput(didLoad: didLoadSubject,
                                          didTapSave: addButton.rx.tap.asObservable())
        let input = interactor.configureIO(with: output)
        
        input?.formItems
            .withUnretained(self)
            .subscribe(onNext: { obj, items in
                obj.updateFormItems(items)
            })
            .disposed(by: bag)
    }
}
