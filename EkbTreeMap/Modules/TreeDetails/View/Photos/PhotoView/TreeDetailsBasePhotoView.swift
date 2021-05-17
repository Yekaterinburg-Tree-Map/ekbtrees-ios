//
//  TreeDetailsBasePhotoView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit


class TreeDetailsBasePhotoView: UIButton {
    
    // MARK: Private Properties
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()
    
    private var action: () -> () = {}
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func configure(with action: @escaping () -> ()) {
        self.action = action
    }
    
    
    // MARK: Private
    
    @objc
    private func didTap() {
        action()
    }
    
    private func setupView() {
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.95, alpha: 1)
        setupConstraints()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        snp.makeConstraints {
            $0.width.height.equalTo(80)
        }
    }
}
