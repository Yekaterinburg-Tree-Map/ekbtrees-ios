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
    
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupIO()
    }
    
    
    // MARK: Private
    
    private func setupConstraint() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
    }
    
    private func setupIO() {
        
    }
}
