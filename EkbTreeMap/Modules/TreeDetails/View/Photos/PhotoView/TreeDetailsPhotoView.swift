//
//  TreeDetailsPhotoView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit


final class TreeDetailsPhotoView: TreeDetailsBasePhotoView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        let image: UIImage?
        let action: () -> ()
    }
    
    // MARK: Private Properties
    
    private lazy var _imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    // MARK: Lifecycle
    
    class func instantiate() -> TreeDetailsPhotoView {
        return TreeDetailsPhotoView(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func configure(with data: DisplayData) {
        _imageView.image = data.image
        configure(with: data.action)
    }
    
    
    // MARK: Private
    
    private func setupView() {
        addSubview(_imageView)
        _imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
