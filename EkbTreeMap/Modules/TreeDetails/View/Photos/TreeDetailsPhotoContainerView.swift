//
//  TreeDetailsPhotoContainerView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 12.05.2021.
//

import UIKit
import RxSwift


protocol TreeDetailsPhotoContainerDelegate: AnyObject {
    
    func photoContainer(_ view: TreeDetailsPhotoContainerView, configureView: TreeDetailsPhotoView, at index: Int)
    func photoContainerDidTapAdd(_ view: TreeDetailsPhotoContainerView)
    func photoContainer(_ view: TreeDetailsPhotoContainerView, didTapItem index: Int)
    func photoContainer(_ view: TreeDetailsPhotoContainerView, didTapClose index: Int)
}

protocol TreeDetailsPhotoContainerDataSource: AnyObject {
    
    func isAddButtonEnabled() -> Bool
    func numberOfItems() -> Int
}


final class TreeDetailsPhotoContainerView: UIView, TreeDetailsPhotoViewDelegate {
    
    // MARK: Private Properties
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .horizontal
        return view
    }()
    
    private var views: [TreeDetailsBasePhotoView] = []
    
    
    // MARK: Public Properties
    
    weak var delegate: TreeDetailsPhotoContainerDelegate?
    weak var dataSource: TreeDetailsPhotoContainerDataSource?
    
    var isAddButtonEnabled: Bool {
        dataSource?.isAddButtonEnabled() ?? false
    }
    
    
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
    
    func reloadData() {
        setupViews()
    }
    
    func photoViewDidTriggerAction(_ view: TreeDetailsBasePhotoView, type: TreeDetailsPhotoViewType) {
        if let _ = view as? TreeDetailsAddPhotoView {
            delegate?.photoContainerDidTapAdd(self)
        }
        if let index = views.firstIndex(of: view) {
            delegate?.photoContainer(self, didTapItem: index)
        }
    }
    
    func photoViewDidTriggerClose(_ view: TreeDetailsBasePhotoView, type: TreeDetailsPhotoViewType) {
        if let index = views.firstIndex(of: view) {
            delegate?.photoContainer(self, didTapClose: index)
        }
    }
    
    func updateView(at index: Int, data: PhotoModelProtocol) {
        guard
            index < views.count,
            let view = views[index] as? TreeDetailsPhotoView else
        {
            return
        }
        
        view.configure(with: data)
    }
    
    
    // MARK: Private
    
    private func setupViews() {
        removeArrangedSubviews()
        setupAddButtonIfNeeded()
        setupPhotoViews()
    }
    
    private func setupAddButtonIfNeeded() {
        if isAddButtonEnabled {
            let view = TreeDetailsAddPhotoView(frame: .zero)
            view.delegate = self
            stackView.addArrangedSubview(view)
        }
    }
    
    private func setupPhotoViews() {
        views = []
        guard let count = dataSource?.numberOfItems(), count > 0 else {
            return
        }

        (0..<count).forEach(addPhotoView)
    }
    
    private func addPhotoView(at index: Int) {
        let view = TreeDetailsPhotoView(frame: .zero)
        view.delegate = self
        stackView.addArrangedSubview(view)
        views.append(view)
        delegate?.photoContainer(self, configureView: view, at: index)
    }
    
    private func removeArrangedSubviews() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
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
