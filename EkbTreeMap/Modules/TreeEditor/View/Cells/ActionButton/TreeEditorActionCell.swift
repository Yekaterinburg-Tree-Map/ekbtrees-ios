//
//  TreeEditorActionCell.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import UIKit


final class TreeEditorActionCell: UIView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        let title: String
        var action: () -> () = {}
    }
    
    
    // MARK: Frame
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    
    
    // MARK: Private Properties
    
    private var action: () -> () = {}
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: Public
    
    func configure(with data: DisplayData) {
        actionButton.setTitle(data.title, for: .normal)
        action = data.action
    }
    
    
    // MARK: Private
    
    @objc
    private func didTapAction() {
        action()
    }
    
    private func setupConstraints() {
        addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}
