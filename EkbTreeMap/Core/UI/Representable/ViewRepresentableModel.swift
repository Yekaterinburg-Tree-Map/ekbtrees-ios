//
//  ViewRepresentableModel.swift
//  EkbTreeMap
//
//  Created by s.petrov on 02.05.2021.
//

import UIKit


protocol ViewRepresentableModel {
    
    func setupView() -> UIView
}


struct GenericViewModel<T: ViewRepresentable>: ViewRepresentableModel where T: UIView {
    
    private let data: T.DisplayData
    init(data: T.DisplayData) {
        self.data = data
    }
    
    func setupView() -> UIView {
        let view = T.instantiate()
        view.configure(with: data)
        return view
    }
}
