//
//  NetworkServiceProtocol.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import RxSwift


protocol NetworkServiceProtocol {
    
    func sendRequestWithEmptyResponse(_ target: Target) -> Observable<Void>
    func sendRequest<Parser: NetworkParser>(_ target: Target, parser: Parser) -> Observable<Parser.Response>
    func sendUploadFileRequest<Parser: NetworkParser>(_ target: Target, parser: Parser) -> Observable<Parser.Response>
}
