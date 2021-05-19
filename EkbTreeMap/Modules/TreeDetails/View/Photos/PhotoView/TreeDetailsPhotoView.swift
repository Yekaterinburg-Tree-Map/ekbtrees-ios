//
//  TreeDetailsPhotoView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit
import UCZProgressView


final class TreeDetailsPhotoView: TreeDetailsBasePhotoView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        enum State {
            case error
            case ready(isDeleteButtonEnabled: Bool)
            case uploading
            case downloading
        }
        
        let image: UIImage?
        let action: () -> ()
        let state: State
    }
    
    // MARK: Private Properties
    
    private lazy var _imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var progressView: UCZProgressView = {
        let view = UCZProgressView(frame: .zero)
        view.lineWidth = 4
        view.radius = 36
        view.tintColor = .white
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var accessoryView: UIImageView = {
        let view = UIImageView()
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
        processState(data.state)
    }
    
    func updateProgress(_ progress: CGFloat) {
        progressView.progress = progress
    }
        
    
    // MARK: Private
    
    private func processState(_ state: DisplayData.State) {
        switch state {
        case .downloading:
            return
        case .error:
            accessoryView.image = UIImage.general.retry
        case .ready(let isDeleteButtonEnabled):
            if isDeleteButtonEnabled {
                closeButton.setImage(UIImage.general.closeCircle, for: .normal)
            }
        case .uploading:
            return
        }
    }
    
    @objc
    private func didTapClose() {
        
    }
    
    private func setupView() {
        addSubview(_imageView)
        _imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        addSubview(accessoryView)
        accessoryView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(32)
        }
    }
}
