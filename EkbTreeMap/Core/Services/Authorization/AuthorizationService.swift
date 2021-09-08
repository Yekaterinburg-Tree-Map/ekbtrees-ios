//
//  AuthorizationService.swift
//  EkbTreeMap
//
//  Created by Pyretttt on 08.09.2021.
//

import RxSwift

protocol AuthorizationServiceProtocol {
	
	func login(email: String, password: String) -> Observable<Void>
	
}

class AuthorizationService: AuthorizationServiceProtocol {
	
	func login(email: String, password: String) -> Observable<Void> {
		.never()
	}
}
