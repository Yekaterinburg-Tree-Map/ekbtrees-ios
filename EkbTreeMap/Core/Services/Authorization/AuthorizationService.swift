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
    
    // MARK: Private Properties

    private let resolver: IResolver
    private let networkService: NetworkServiceProtocol
	
    
    // MARK: Lifecycle
    
    init(resolver: IResolver,
         networkService: NetworkServiceProtocol) {
        self.resolver = resolver
        self.networkService = networkService
    }
    
    
    // MARK: Public
    
	func login(email: String, password: String) -> Observable<Void> {
        let target: SignInTarget = resolver.resolve(
            arg: SignInTarget.Parameters(email: email, password: password)
        )
        return networkService.sendRequestWithEmptyResponse(target)
	}
}
