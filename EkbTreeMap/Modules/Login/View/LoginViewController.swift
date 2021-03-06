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
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var vkEntryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Авторизация ВК", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var facebookEntry: UIButton = {
        let button = UIButton()
        button.setTitle("Авторизация facebook", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var appleEntry: UIButton = {
        let button = UIButton()
        button.setTitle("Авторизация Apple", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    
    // MARK: Public Properties
    
    var interactor: LoginViewConfigurable!
    
    
    // MARK: Private Properties
    
    private let bag = DisposeBag()
    private let didLoadSubject = PublishSubject<Void>()
    private let didTapEnter = PublishSubject<(String?, String?)>()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        fillStackView()
        setupUI()
        configureIO()
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    private func fillStackView() {
        [loginTitle, emailTextField, passwordTextField, signInButton].forEach {
            formStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        view.addSubview(formStackView)
        formStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(64)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualToSuperview()
            $0.height.greaterThanOrEqualTo(100).priority(.low)
        }
    }
    
    private func configureIO() {
        let input = interactor.configure(with: .init(didLoad: didLoadSubject,
                                                     didTapEnter: didTapEnter))
        
        input.title
            .bind(to: loginTitle.rx.text)
            .disposed(by: bag)
        
        input.availableButton
            .withUnretained(self)
            .subscribe(onNext: { $0.addEntryButtons($1) })
            .disposed(by: bag)
    }
    
    private func addEntryButtons(_ buttons: [LoginButtonType]) {
        buttons.forEach {
            let view: UIView
            switch $0 {
            case .vk:
                view = vkEntryButton
            case .facebook:
                view = facebookEntry
            case .apple:
                view = appleEntry
            }
            formStackView.addArrangedSubview(view)
        }
    }
}
