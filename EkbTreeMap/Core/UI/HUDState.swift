//
//  HUDState.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.05.2021.
//

import Foundation


enum HUDState: Equatable {
    
    case hidden
    case loading
    case failure(duration: TimeInterval, completion: () -> ())
    case success(duration: TimeInterval, completion: () -> ())
    
    static func == (lhs: HUDState, rhs: HUDState) -> Bool {
        switch (lhs, rhs) {
        case (.hidden, .hidden):
            return true
        case (.loading, .loading):
            return true
        case (.failure, .failure):
            return true
        case (.success, .success):
            return true
        default:
            return false
        }
    }
}
