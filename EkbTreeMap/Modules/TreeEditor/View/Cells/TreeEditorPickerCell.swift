//
//  TreeEditorPickerCell.swift
//  EkbTreeMap
//
//  Created by s.petrov on 29.04.2021.
//

import UIKit


final class TreeEditorPickerCell: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Frame
    
    private lazy var titleLabel: UILabel = {
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
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    
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
    
    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
        }
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).inset(8)
        }
    }
}
