//
//  TreeEditorStepperCell.swift
//  EkbTreeMap
//
//  Created by s.petrov on 27.04.2021.
//
import UIKit


final class TreeEditorStepperCell: UIView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        let title: String
        let value: Double?
        var minStepperValue: Double = 0
        var maxStepperValue: Double = 5
        
        var action: (Int) -> () = { _ in return }
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
    
    private lazy var valueLabel: UILabel = {
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
    
    private lazy var stepper: UIStepper = {
        let view = UIStepper()
        view.value = 0
        view.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return view
    }()
    
    
    // MARK: Private Properties
    
    private var action: (Int) -> () = { _ in return }
    
    
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
        stepper.minimumValue = data.minStepperValue
        stepper.maximumValue = data.maxStepperValue
        if let value = data.value {
            valueLabel.text = "\(value)"
            stepper.value = value
        } else {
            valueLabel.text = nil
            stepper.value = data.minStepperValue
        }
        action = data.action
    }
    
    
    // MARK: Private
    
    @objc
    private func stepperValueChanged(sender: UIStepper) {
        let value = Int(sender.value)
        valueLabel.text = "\(value)"
        action(value)
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(16)
        }
        
        addSubview(stepper)
        stepper.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            $0.centerY.equalTo(stepper)
            $0.right.equalTo(stepper.snp.left).inset(-16)
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}
