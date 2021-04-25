//
//  MapPointChooserModuleIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.04.2021.
//

import CoreLocation


protocol MapPointChooserModuleOutput: AnyObject {
    
    func didSelectPoint(with location: CLLocationCoordinate2D)
    func didTapClose()
}
