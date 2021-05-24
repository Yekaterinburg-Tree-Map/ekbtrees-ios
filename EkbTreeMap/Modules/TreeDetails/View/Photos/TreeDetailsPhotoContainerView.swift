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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 90, height: 96)
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .clear
        v.register(TreeDetailsAddPhotoView.self, forCellWithReuseIdentifier: TreeDetailsAddPhotoView.reuseIdentifier)
        v.register(TreeDetailsPhotoView.self, forCellWithReuseIdentifier: TreeDetailsPhotoView.reuseIdentifier)
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    private var contentOffset: Int {
        isAddButtonEnabled ? 1 : 0
    }
    
    
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
        collectionView.reloadData()
    }
    
    func photoViewDidTriggerAction(_ view: TreeDetailsBasePhotoView, type: TreeDetailsPhotoViewType) {
        if let _ = view as? TreeDetailsAddPhotoView {
            delegate?.photoContainerDidTapAdd(self)
        }
        if let path = collectionView.indexPath(for: view) {
            delegate?.photoContainer(self, didTapItem: path.item - contentOffset)
        }
    }
    
    func photoViewDidTriggerClose(_ view: TreeDetailsBasePhotoView, type: TreeDetailsPhotoViewType) {
        if let path = collectionView.indexPath(for: view) {
            delegate?.photoContainer(self, didTapClose: path.item - contentOffset)
        }
    }
    
    func updateView(at index: Int, data: PhotoModelProtocol) {
        guard let view = collectionView.cellForItem(at: .init(item: index + contentOffset, section: 0))
                as? TreeDetailsPhotoView else {
            return
        }
        view.configure(with: data)
    }
    
    
    // MARK: Private
    
    private func setupConstraints() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(96)
        }
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TreeDetailsPhotoContainerView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (dataSource?.numberOfItems() ?? 0) + contentOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TreeDetailsAddPhotoView.reuseIdentifier,
                                                          for: indexPath) as! TreeDetailsAddPhotoView
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TreeDetailsPhotoView.reuseIdentifier,
                                                          for: indexPath) as! TreeDetailsPhotoView
            cell.delegate = self
            delegate?.photoContainer(self, configureView: cell, at: indexPath.item - contentOffset)
            return cell
        }
    }
}
