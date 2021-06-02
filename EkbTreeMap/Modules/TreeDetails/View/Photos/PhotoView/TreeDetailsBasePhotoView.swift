//
//  TreeDetailsBasePhotoView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit


class TreeDetailsBasePhotoView: UICollectionViewCell {
    
    // MARK: Public Properties
    
    lazy var containerView = UIButton()
    weak var delegate: TreeDetailsPhotoViewDelegate?
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func didTapAction() {
        
    }
    
    
    // MARK: Private
    
    @objc
    private func didTap() {
        didTapAction()
    }
    
    private func setupView() {
        containerView.layer.cornerRadius = 8
        backgroundColor = .clear
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.95, alpha: 1)
        setupConstraints()
        containerView.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(96)
        }
    }
}
