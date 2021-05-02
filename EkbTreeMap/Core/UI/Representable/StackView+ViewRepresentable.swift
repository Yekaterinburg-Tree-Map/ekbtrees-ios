//
//  StackView+ViewRepresentable.swift
//  EkbTreeMap
//
//  Created by s.petrov on 02.05.2021.
//

import UIKit


final class ViewRepresentableStackView: UIStackView {
    
    // MARK: Public
    
    func updateItems(_ items: [ViewRepresentableModel]) {
        removeArrangedSubviews()
        for item in items {
            let view = item.setupView()
            addArrangedSubview(view)
        }
    }
    
    
    // MARK: Private
    
    private func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
