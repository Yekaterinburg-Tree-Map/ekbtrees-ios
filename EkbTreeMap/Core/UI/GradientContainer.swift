//
//  GradientContainer.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.05.2021.
//

import UIKit


final class GradientContainer: UIView {
    
    // MARK: Public
    
    func setupGradient(colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = .init(x: 0, y: 0)
        gradient.endPoint = .init(x: 0, y: 0.5)
        layer.insertSublayer(gradient, at: 0)
    }
}
