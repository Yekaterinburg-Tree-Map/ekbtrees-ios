//
//  LoginViewIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 08.04.2021.
//

import Foundation
import RxSwift


struct LoginViewOutput {
    
    var didLoad: Observable<Void> = .never()
    var didTapEnter: Observable<(String?, String?)> = .never()
    var didTapVK: Observable<Void> = .never()
    var didTapFacebook: Observable<Void> = .never()
    var didTapApple: Observable<Void> = .never()
}

struct LoginViewInput {
    
    var title: Observable<String> = .never()
    var availableButton: Observable<[LoginButtonType]> = .never()
}
