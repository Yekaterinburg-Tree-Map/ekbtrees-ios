//
//  TreeEditorPickerCell.swift
//  EkbTreeMap
//
//  Created by s.petrov on 29.04.2021.
//

import UIKit
import SnapKit


final class TreeEditorPickerCell: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Frame
    
    private lazy var titleButton: ButtonWithArrowDown = {
        let button = ButtonWithArrowDown(frame: .zero)
        button.addTarget(self, action: #selector(didTapTitleButton), for: .touchUpInside)
        return button
    }()
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    
    // MARK: Private Properties
    
    private var pickerHeightHiddenConstraint: Constraint!
    private var pickerHeightShownConstraint: Constraint!
    
    private var isPickerShown = false {
        didSet {
            if isPickerShown {
                pickerHeightShownConstraint.activate()
                pickerHeightHiddenConstraint.deactivate()
            } else {
                pickerHeightShownConstraint.deactivate()
                pickerHeightHiddenConstraint.activate()
            }
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
    
    
    // MARK: Public
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        5
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row)"
    }
    
    
    // MARK: Private
    
    @objc
    private func didTapTitleButton() {
        isPickerShown.toggle()
    }
    
    private func setupConstraints() {
        addSubview(titleButton)
        titleButton.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
        }
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(16)
            $0.top.equalTo(titleButton.snp.bottom).inset(8)
            pickerHeightHiddenConstraint = $0.height.equalTo(0).constraint
            pickerHeightShownConstraint = $0.height.greaterThanOrEqualTo(0).constraint
            pickerHeightShownConstraint.deactivate()
        }
    }
}
