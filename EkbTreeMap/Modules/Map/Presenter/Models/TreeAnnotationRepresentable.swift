//
//  TreeAnnotationRepresentable.swift
//  EkbTreeMap
//
//  Created by s.petrov on 11.04.2021.
//

import Foundation


enum TreeAnnotationState {
    
    case visible(TreeAnnotationRepresentable)
    case hidden
}


struct TreeAnnotationRepresentable {
    
    let title: String
    let buttonText: String
}
