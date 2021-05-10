//
//  TreeEditorPickerCell.swift
//  EkbTreeMap
//
//  Created by s.petrov on 29.04.2021.
//

import UIKit
import SnapKit


final class TreeEditorPickerCell: UIView, ViewRepresentable, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        let title: String
        let value: String?
        var pickerValues: [String] = []
        
        var action: (String?) -> () = { _ in return }
    }
    
    
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
    
    private var value: String?
    private var pickerValues: [String] = []
    private var selectAction: (String?) -> () = { _ in return }
    
    private var isPickerShown = false {
        didSet {
            if isPickerShown {
                pickerHeightShownConstraint.activate()
                pickerHeightHiddenConstraint.deactivate()
                UIView.animate(withDuration: 0.2, animations: {
                    self.pickerView.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.pickerView.alpha = 0
                }, completion: { _ in
                    self.pickerHeightShownConstraint.deactivate()
                    self.pickerHeightHiddenConstraint.activate()
                })
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
    
    func configure(with data: DisplayData) {
        titleButton.configure(with: .init(title: data.title, subtitle: data.value))
        configurePicker(data: data)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerValues.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        value = pickerValues[row]
        titleButton.updateSubtitle(value)
        selectAction(value)
    }
    
    
    // MARK: Private
    
    @objc
    private func didTapTitleButton() {
        isPickerShown.toggle()
    }
    
    private func configurePicker(data: DisplayData) {
        pickerValues = data.pickerValues
        let row = data.pickerValues.enumerated()
            .filter { $0.element == data.value }
            .map(\.offset)
            .first ?? 0
        pickerView.selectRow(row, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
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
