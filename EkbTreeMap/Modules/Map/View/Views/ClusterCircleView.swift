//
//  ClusterCircleView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 27.05.2021.
//

import UIKit


final class ClusterCircleView: UIView {
    
    // MARK: Private Properties
    
    private var containerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var label: UILabel = {
        let view = UILabel()
        view.adjustsFontSizeToFitWidth = true
        view.textAlignment = .center
        return view
    }()
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func configure(with data: TreeClusterRepresentable) {
        label.text = data.countString
        containerView.backgroundColor = data.color
    }
    
    
    // MARK: Private
    
    private func setupView() {
//        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(2)
        }
        
        snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
    }
}
