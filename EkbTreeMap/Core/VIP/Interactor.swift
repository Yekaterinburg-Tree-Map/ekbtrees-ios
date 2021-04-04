//
//  Interactor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import RxSwift


protocol Interactor: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func configureIO(with: Input) -> Output
}
