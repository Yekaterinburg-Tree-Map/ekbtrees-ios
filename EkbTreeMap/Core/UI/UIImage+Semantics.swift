//
//  UIImage+Semantics.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.04.2021.
//

import UIKit


extension UIImage {
    
    enum general {
        static var checkmark: UIImage? { UIImage(named: "checkmark") }
        static var plus: UIImage? { UIImage(named: "plus") }
        static var arrowDown: UIImage? { UIImage(named: "arrow_down") }
        static var userMale: UIImage? { UIImage(named: "user-male") }
    }
    
    enum map {
        static var placemark: UIImage? { UIImage(named: "placemark") }
    }
}
