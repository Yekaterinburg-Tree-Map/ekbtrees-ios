//
//  TreeEditorEnterDataCell.swift
//  EkbTreeMap
//
//  Created by s.petrov on 27.04.2021.
//

import UIKit


final class TreeEditorEnterDataCell: UIView, ViewRepresentable, UITextFieldDelegate {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        let title: String
        let placeholder: String
        let data: String?
        let isFailed: Bool
        
        var action: (String) -> () = { _ in return }
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
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = UIFont.systemFont(ofSize: 18)
        field.keyboardType = .decimalPad
        field.placeholder = "enter here"
        field.delegate = self
        return field
    }()
    
    
    // MARK: Private Properties
    
    private var action: (String) -> () = { _ in return }
    
    
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
        textField.text = data.data
        textField.placeholder = data.placeholder
        action = data.action
        if data.isFailed {
            titleLabel.textColor = .systemRed
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        action(textField.text ?? "")
    }

    
    // MARK: Private
    
    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        addSubview(textField)
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).inset(-8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
