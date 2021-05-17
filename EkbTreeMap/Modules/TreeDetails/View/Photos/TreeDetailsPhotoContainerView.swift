//
//  TreeDetailsPhotoContainerView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 12.05.2021.
//

import UIKit
import RxSwift


final class TreeDetailsPhotoContainerView: UIView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        let photoItems: [ViewRepresentableModel]
    }
    
    
    // MARK: Private Properties
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .horizontal
        return view
    }()
    
    
    // MARK: Lifecycle
    
    class func instantiate() -> TreeDetailsPhotoContainerView {
        TreeDetailsPhotoContainerView(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func configure(with data: DisplayData) {
        data.photoItems.forEach {
            stackView.addArrangedSubview($0.setupView())
        }
    }
    
    
    // MARK: Private
    
    private func setupConstraints() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalTo(self)
            $0.left.right.equalToSuperview()
        }
    }
}


extension Reactive where Base == TreeDetailsPhotoContainerView {
    
    var data: Binder<TreeDetailsPhotoContainerView.DisplayData> {
        Binder(self.base) { view, data in
            view.configure(with: data)
        }
    }
}
