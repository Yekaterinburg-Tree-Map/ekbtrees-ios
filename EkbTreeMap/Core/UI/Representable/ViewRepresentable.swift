//
//  ViewRepresentable.swift
//  EkbTreeMap
//
//  Created by s.petrov on 02.05.2021.
//

import UIKit


protocol ViewRepresentable {
    associatedtype DisplayData
    
    func configure(with: DisplayData)
    static func instantiate() -> Self
}


extension ViewRepresentable where Self: UIView {
    
    static func instantiate() -> Self {
        Self(frame: .zero)
    }
}
