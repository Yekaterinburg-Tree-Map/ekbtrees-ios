//
//  LoginInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 08.04.2021.
//

import RxSwift


class LoginInteractor: AnyInteractor<LoginViewOutput, LoginViewInput> {
    
    // MARK: Private Properties
    
    private let titleSubject = BehaviorSubject<String>(value: "Вход")
    private let availableButtons = BehaviorSubject<[LoginButtonType]>(value: [])
    private let bag = DisposeBag()
    
    
    
    // MARK: Public
    
    override func configureIO(with output: LoginViewOutput) -> LoginViewInput? {
        
        output.didLoad
            .subscribe(onNext: { [weak self] in self?.didLoad() })
            .disposed(by: bag)
        
        output.didTapEnter
            .subscribe(onNext: { [weak self] creds in
                self?.didTapEnter(email: creds.0, password: creds.1)
            })
            .disposed(by: bag)
        
        return LoginViewInput(title: titleSubject, availableButton: availableButtons)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        
    }
    
    private func didTapEnter(email: String?, password: String?) {
        guard validateInput(email: email, password: password) else {
            // show 
            return
        }
    }
    
    private func validateInput(email: String?, password: String?) -> Bool {
        // add regex for email
        email != nil && password != nil
    }
}
