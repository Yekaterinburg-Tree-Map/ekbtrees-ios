//
//  MapPointChooserModuleIO.swift
//  EkbTreeMap
//
//  Created by s.petrov on 24.04.2021.
//


protocol MapPointChooserModuleOutput: AnyObject {
    
    func didSelectPoint(with location: TreePosition)
    func didTapClose()
}
