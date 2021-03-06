//
//  LoginInteractor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 08.04.2021.
//

import RxSwift


class LoginInteractor: LoginViewConfigurable {
    
    // MARK: Private Properties
    
    private let titleSubject = BehaviorSubject<String>(value: "Вход")
    private let availableButtons = BehaviorSubject<[LoginButtonType]>(value: [])
    private let bag = DisposeBag()
    
    
    
    // MARK: Public
    
    func configure(with output: LoginView.Output) -> LoginView.Input {
        
        output.didLoad
            .subscribe(onNext: { [weak self] in self?.didLoad() })
            .disposed(by: bag)
        
        output.didTapEnter
            .subscribe(onNext: { [weak self] creds in
                self?.didTapEnter(email: creds.0, password: creds.1)
            })
            .disposed(by: bag)
        
        return LoginView.Input(title: titleSubject, availableButton: availableButtons)
    }
    
    
    // MARK: Private
    
    private func didLoad() {
        // update available buttons
        // check if already logged in(should be in another place)
        
    }
    
    private func didTapEnter(email: String?, password: String?) {
        guard validateInput(email: email, password: password) else {
            // show validation issues
            return
        }
    }
    
    private func validateInput(email: String?, password: String?) -> Bool {
        // add regex for email
        email != nil && password != nil
    }
}
