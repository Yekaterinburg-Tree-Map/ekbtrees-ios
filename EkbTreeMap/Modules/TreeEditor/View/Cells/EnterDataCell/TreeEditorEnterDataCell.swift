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
        return label
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = UIFont.systemFont(ofSize: 18)
        field.keyboardType = .decimalPad
        field.placeholder = "enter here"
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
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        action(textField.text ?? "")
    }

    
    // MARK: Private
    
    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        
        addSubview(textField)
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(16)
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right).inset(-8)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}
