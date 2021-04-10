//
//  Presenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 10.04.2021.
//


protocol Presenter {
    associatedtype Input
    associatedtype Output
    
    func configureIO(with: Input) -> Output?
}


class AnyPresenter<Input, Output>: Presenter {
    
    func configureIO(with: Input) -> Output? {
        nil
    }
}
