//
//  SignInTarget.swift
//  EkbTreeMap
//
//  Created by Pyretttt on 08.09.2021.
//

import Moya

final class SignInTarget: AuthorizedTarget {
	
	// MARK: Public Structures
	
	struct Parameters {
		let email: String
		let password: String
	}
	
	// MARK: Public Properties
	
	var baseURL: URL
	
	var path: String {
		"/auth/login"
	}
    
    var authorizationType: AuthorizationType? {
        guard let authorization = "\(params.email):\(params.password)".data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        
        return .custom(authorization)
    }
	
	var method: Method = .post
	
	var sampleData: Data = Data()
	
	var task: Task {
		return .requestPlain
	}
	
	var headers: [String : String]? = nil
	
	
	// MARK: Private Properties
	
	private let params: Parameters
	
	
	// MARK: Lifecycle
	
	init(baseURL: String, params: Parameters) {
		self.params = params
		guard let url = URL(string: baseURL) else {
			self.baseURL = URL(fileReferenceLiteralResourceName: "")
			return
		}
		self.baseURL = url
	}
}
