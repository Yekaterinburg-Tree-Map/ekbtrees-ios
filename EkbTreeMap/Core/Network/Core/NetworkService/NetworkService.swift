//
//  NetworkService.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.05.2021.
//

import Moya
import RxSwift
import SwiftyJSON


class NetworkService: NetworkServiceProtocol {
    
    // MARK: Private Properties
    
    private let provider: MoyaProvider<MultiTarget>
    
    
    // MARK: Lifecycle
    
    init(plugins: [PluginType] = []) {
        provider = MoyaProvider<MultiTarget>(plugins: plugins)
    }
    
    
    // MARK: Public
    
    func sendRequest<Parser: NetworkParser>(_ target: Target, parser: Parser) -> Observable<Parser.Response> {
        return innerSendRequest(target)
            .flatMap { [weak self] response -> Observable<Parser.Response> in
                guard let self = self else {
                    return .error(NetworkError.wrongResponse)
                }
                
                return self.parseData(parser: parser, response: response)
            }
    }
    
    func sendUploadFileRequest<Parser: NetworkParser>(_ target: Target, parser: Parser) -> Observable<Parser.Response> {
        .empty()
    }
    
    
    // MARK: Private
    
    private func innerSendRequest(_ target: Target) -> Observable<Moya.Response> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                return Disposables.create {}
            }
            let completion: Moya.Completion = { result in
                switch result {
                case .success(let response):
                    do {
                        try response.filterSuccessfulStatusAndRedirectCodes()
                        observer.onNext(response)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            let cancellable = self.provider.request(MultiTarget(target), completion: completion)
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
    
    private func parseData<Parser: NetworkParser>(parser: Parser,
                                                  response: Moya.Response) -> Observable<Parser.Response> {
        do {
            let json = try JSON(data: response.data)
            let result = try parser.parse(data: json)
            return .just(result, scheduler: MainScheduler.asyncInstance)
        } catch {
            return .error(error)
        }
    }
}
