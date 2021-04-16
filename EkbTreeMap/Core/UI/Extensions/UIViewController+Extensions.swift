//
//  UIViewController+Extensions.swift
//  EkbTreeMap
//
//  Created by s.petrov on 16.04.2021.
//

import UIKit


extension UIViewController {
    
    func embedViewController(_ vc: UIViewController, to container: UIView) {
        vc.willMove(toParent: self)
        container.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
    }
}
