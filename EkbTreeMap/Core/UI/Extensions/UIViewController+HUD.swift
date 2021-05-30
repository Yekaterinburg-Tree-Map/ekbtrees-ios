//
//  UIViewController+HUD.swift
//  EkbTreeMap
//
//  Created by s.petrov on 30.05.2021.
//

import UIKit
import SVProgressHUD


extension UIViewController {
        
    func updateHUDState(_ state: HUDState) {
        view.isUserInteractionEnabled = state == .hidden
        switch state {
        case .hidden:
            SVProgressHUD.dismiss()
        case .loading:
            SVProgressHUD.show()
        case .failure(let duration, let completion):
            SVProgressHUD.showError(withStatus: nil)
            SVProgressHUD.dismiss(withDelay: duration, completion: completion)
        case .success(let duration, let completion):
            SVProgressHUD.showSuccess(withStatus: nil)
            SVProgressHUD.dismiss(withDelay: duration, completion: completion)
        }
    }
}
