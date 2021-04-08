//
//  Interactor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 08.04.2021.
//

import Foundation


protocol Interactor {
    associatedtype Input
    associatedtype Output
    
    func configureIO(with: Input) -> Output?
}


class AnyInteractor<Input, Output>: Interactor {
    
    func configureIO(with: Input) -> Output? {
        nil
    }
}
