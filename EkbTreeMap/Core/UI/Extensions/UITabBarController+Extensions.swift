//
//  UITabBarController+Extensions.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import UIKit


extension UITabBarController {
    
    func append(_ controller: UIViewController) {
        viewControllers == nil
            ? viewControllers = [controller]
            : viewControllers?.append(controller)
    }
}
