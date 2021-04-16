//
//  Factory.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.04.2021.
//

import Foundation


protocol Factory {
    associatedtype Context
    associatedtype Result
    
    func build(with: Context) -> Result
}
