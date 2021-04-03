//
//  CircleImage.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import UIKit


extension UIImage {
    
    class func circle(radius: CGFloat, color: UIColor) -> UIImage? {
        let size = CGSize(width: radius, height: radius)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.saveGState()
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        context.restoreGState()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
