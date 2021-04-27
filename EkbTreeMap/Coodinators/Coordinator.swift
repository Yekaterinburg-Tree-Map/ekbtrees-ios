//
//  Coordinator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 04.04.2021.
//

import Foundation


protocol Coordinator: AnyObject {
    
    func start(animated: Bool)
    func finish(animated: Bool)
}


protocol ParentCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] { get }
}


protocol CoordinatorDelegate: AnyObject {
    
    func coordinator(_ coordinator: Coordinator, wantsToFinishAnimated: Bool)
}
