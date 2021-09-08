//
//  LoginViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 08.04.2021.
//

import Foundation
import RxSwift


struct LoginView {
    
    struct Input {
        
        var title: Observable<String> = .never()
        var availableButton: Observable<[LoginButtonType]> = .never()
    }
    
    struct Output {
        
        var didLoad: Observable<Void> = .never()
        var didTapEnter: Observable<(String?, String?)> = .never()
        var didTapVK: Observable<Void> = .never()
        var didTapFacebook: Observable<Void> = .never()
        var didTapApple: Observable<Void> = .never()
    }
}


protocol LoginViewConfigurable {
    func configure(with output: LoginView.Output) -> LoginView.Input
}
