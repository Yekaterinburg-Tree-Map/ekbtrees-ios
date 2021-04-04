//
//  Presenter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation


protocol Presenter {
    associatedtype Input
    associatedtype Output
    
    func configureIO(with: Input) -> Output
}
