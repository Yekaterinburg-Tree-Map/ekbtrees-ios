//
//  LoginViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 06.04.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class LoginViewController: UIViewController {
    
    // MARK: Frame
    
    private lazy var formStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var loginTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }
        label.text = "Вход"
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Введите email"
        return field
    }()
    
    private lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Введите пароль"
        field.isSecureTextEntry = true
        return field
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        return button
    }()
    
    private lazy var vkEntryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Авторизация ВК", for: .normal)
        return button
    }()
    
    private lazy var facebookEntry: UIButton = {
        let button = UIButton()
        button.setTitle("Авторизация facebook", for: .normal)
        return button
    }()
    
    private lazy var appleEntry: UIButton = {
        let button = UIButton()
        button.setTitle("Авторизация Apple", for: .normal)
        return button
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        fillStackView()
    }
    
    
    // MARK: Private
    
    private func fillStackView() {
        [loginTitle, emailTextField, passwordTextField, signInButton, vkEntryButton, facebookEntry, appleEntry].forEach {
            formStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        view.addSubview(formStackView)
        formStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(64)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.greaterThanOrEqualToSuperview()
            $0.height.greaterThanOrEqualTo(100).priority(.low)
        }
    }
}
