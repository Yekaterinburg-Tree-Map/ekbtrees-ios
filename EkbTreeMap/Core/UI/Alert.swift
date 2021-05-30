//
//  Alert.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.05.2021.
//

import UIKit


struct Alert {
    
    let title: String?
    let message: String
    var actions: [AlertAction] = []
    
    init(title: String? = nil, message: String = "") {
        self.title = title
        self.message = message
    }
}


struct AlertAction {
    
    let title: String
    let style: AlertActionStyle
    let handler: () -> ()
    
    init(title: String, style: AlertActionStyle = .default, handler: @escaping () -> () = {}) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

enum AlertActionStyle {
    case `default`
    case cancel
    case destructive
}


extension UIAlertController {
    
    convenience init(alert: Alert) {
        self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
        
        for action in alert.actions {
            let alertActionStyle: UIAlertAction.Style = {
                switch action.style {
                case .default:
                    return .default
                    
                case .destructive:
                    return .destructive
                    
                case .cancel:
                    return .cancel
                }
            }()
            
            let action = UIAlertAction(title: action.title, style: alertActionStyle, handler: { _ in
                action.handler()
            })
            
            self.addAction(action)
        }
    }
}
