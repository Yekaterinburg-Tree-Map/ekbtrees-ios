//
//  CircleImagedButton.swift
//  EkbTreeMap
//
//  Created by s.petrov on 14.04.2021.
//

import UIKit
import RxSwift


final class CircleImagedButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 64, height: 64)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = UIColor.black.withAlphaComponent(0.2)
            } else {
                backgroundColor = .white
            }
        }
    }
    
    // MARK: Frame
    
    fileprivate lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 32
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 2
        layer.shadowOffset = .init(width: 0, height: 3)
    }
    
    private func setupConstraints() {
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(32)
        }
    }
}


extension Reactive where Base == CircleImagedButton {
    
    var icon: Binder<UIImage?> {
        Binder(self.base) { view, image in
            view.iconView.image = image
        }
    }
}
