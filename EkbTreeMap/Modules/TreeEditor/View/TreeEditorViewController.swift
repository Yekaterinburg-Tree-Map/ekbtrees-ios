//
//  TreeEditorViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 19.04.2021.
//

import UIKit
import RxSwift
import RxCocoa


final class TreeEditorViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Frame
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 64
        table.delegate = self
        return table
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
        
        didLoadSubject.onNext(())
    }
    
    
    // MARK: Private
    
    private func setupConstraint() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
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
        
        
    }
}
