//
//  TreeDetailsAddPhotoView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 12.05.2021.
//

import UIKit


final class TreeDetailsAddPhotoView: TreeDetailsBasePhotoView {
    
    // MARK: Private Properties
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()
    
    
    // MARK: Lifecycle
    
    class func instantiate() -> TreeDetailsAddPhotoView {
        TreeDetailsAddPhotoView(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        iconView.image = UIImage.general.plus_colored
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    override func didTapAction() {
        delegate?.photoViewDidTriggerAction(self, type: .photo)
    }
    
    
    // MARK: Private
    
    private func setupConstraints() {
        containerView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(32)
        }
    }
}
