//
//  TreeEditorDataCell.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.04.2021.
//

import UIKit


final class TreeEditorDataCell: UIView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        let title: String
        let subtitle: String
    }
    
    
    // MARK: Frame
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }
        return label
    }()
    
    private lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.secondaryLabel
        } else {
            label.textColor = UIColor.darkGray
        }
        label.textAlignment = .right
        return label
    }()
    
    
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
        titleLabel.text = data.title
        dataLabel.text = data.subtitle
    }
    
    
    // MARK: Private
    
    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        
        addSubview(dataLabel)
        dataLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dataLabel.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(16)
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right).inset(8)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}
