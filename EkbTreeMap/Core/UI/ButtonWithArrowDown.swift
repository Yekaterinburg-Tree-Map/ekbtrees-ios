//
//  ButtonWithArrowDown.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.04.2021.
//

import UIKit

final class ButtonWithArrowDown: UIButton {
    
    // MARK: Frame
    
    private lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }
        label.text = "Picker"
        return label
    }()
    
    private lazy var arrowDown: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.general.arrowDown
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            changeTitleColor(isHighlighted: isHighlighted)
        }
    }
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: Private
    
    private func changeTitleColor(isHighlighted: Bool) {
        if isHighlighted {
            dataLabel.textColor = UIColor.systemBlue
        } else {
            if #available(iOS 13.0, *) {
                dataLabel.textColor = UIColor.label
            } else {
                dataLabel.textColor = UIColor.black
            }
        }
    }
    
    private func setupConstraints() {
        addSubview(dataLabel)
        dataLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        addSubview(arrowDown)
        arrowDown.snp.makeConstraints {
            $0.centerY.equalTo(dataLabel)
            $0.right.equalToSuperview()
            $0.left.equalTo(dataLabel.snp.right).inset(16)
            $0.width.height.equalTo(16)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(32)
        }
    }
}
