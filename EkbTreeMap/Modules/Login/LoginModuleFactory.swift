//
//  LoginModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 06.04.2021.
//

import UIKit


final class LoginModuleFactory: Factory {
    
	private let authService: AuthorizationServiceProtocol
	
	init(authService: AuthorizationServiceProtocol) {
		self.authService = authService
	}
	
	func build(with: Void) -> UIViewController {
        let vc = LoginViewController()
        let interactor = LoginInteractor(authorizationService: authService)
        
        vc.interactor = interactor
        return vc
    }
}
