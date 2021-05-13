//
//  TreeDetailsAddPhotoView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 12.05.2021.
//

import UIKit


final class TreeDetailsAddPhotoView: TreeDetailsBasePhotoView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        let action: () -> ()
    }
    
    
    // MARK: Private Properties
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()
    
    private var action: () -> () = {}
    
    
    // MARK: Lifecycle
    
    class func instantiate() -> TreeDetailsAddPhotoView {
        TreeDetailsAddPhotoView(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        iconView.image = UIImage.general.plus_colored
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func configure(with data: DisplayData) {
        configure(with: data.action)
    }
    
    
    // MARK: Private
    
    private func setupConstraints() {
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(32)
        }
    }
}
