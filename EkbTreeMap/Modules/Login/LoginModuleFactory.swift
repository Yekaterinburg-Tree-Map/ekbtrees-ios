//
//  LoginModuleFactory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 06.04.2021.
//

import UIKit


final class LoginModuleFactory: Factory {
    
    func build(with: Void) -> UIViewController {
        let vc = LoginViewController()
        let interactor = LoginInteractor()
        
        vc.interactor = interactor
        return vc
    }
}
