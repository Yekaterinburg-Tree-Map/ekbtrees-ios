//
//  TreeDetailsPhotoView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 13.05.2021.
//

import UIKit
import NVActivityIndicatorView
import Imaginary
import RxSwift


enum PhotoViewState {
    case error
    case ready
    case uploading
    case downloading
    case cancelled
}


final class TreeDetailsPhotoView: TreeDetailsBasePhotoView {
    
    static let reuseIdentifier = "TreeDetailsPhotoView"
    
    // MARK: Public Properties
    
    var isCloseButtonShown: Bool = false {
        didSet {
            updateCloseButton()
        }
    }
    
    
    // MARK: Private Properties
    
    private var bag = DisposeBag()
    
    private lazy var _imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var progressView: NVActivityIndicatorView = {
        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let view = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: .white, padding: nil)
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.general.closeCircle, for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var accessoryView: UIImageView = {
        let view = UIImageView(image: UIImage.general.retry)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _imageView.image = nil
    }
    
    
    // MARK: Public
    
    func configure(with data: PhotoModelProtocol) {
        if let model = data as? LocalPhotoModel {
            updateView(data: model)
        }
        
        if let model = data as? RemotePhotoModel {
            updateView(data: model)
        }
    }
    
    override func didTapAction() {
        delegate?.photoViewDidTriggerAction(self, type: .photo)
    }
        
    
    // MARK: Private
    
    private func updateCloseButton() {
        closeButton.isHidden = !isCloseButtonShown
    }
    
    private func updateView(data: RemotePhotoModel) {
        _imageView.setImage(url: data.url) { [weak self] result in
            switch result {
            case .value:
                self?.processState(.ready)
            case .error:
                self?.updateView(data: data)
            }
        }
        closeButton.isHidden = false
        processState(.downloading)
    }
    
    private func updateView(data: LocalPhotoModel) {
        _imageView.image = data.image
        closeButton.isHidden = true
        switch data.loadStatus {
        case .ready:
            processState(.ready)
        case .loading, .pending:
            processState(.uploading)
        case .cancelled:
            processState(.cancelled)
        }
    }
    
    private func processState(_ state: PhotoViewState) {
        progressView.isHidden = state != .uploading
        accessoryView.isHidden = state == .ready
        switch state {
        case .cancelled:
            accessoryView.image = UIImage.general.retry
        case .ready:
            return
        case .error:
            accessoryView.image = UIImage.general.retry
        case .uploading:
            accessoryView.image = UIImage.general.closeCircle
            progressView.startAnimating()
        case .downloading:
            accessoryView.isHidden = true
            progressView.isHidden = false
            progressView.startAnimating()
        }
    }
    
    @objc
    private func didTapClose() {
        delegate?.photoViewDidTriggerClose(self, type: .photo)
    }
    
    private func setupView() {
        containerView.addSubview(_imageView)
        _imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).inset(-8)
            $0.right.equalTo(containerView.snp.right).inset(-8)
            $0.width.height.equalTo(24)
        }
        
        containerView.addSubview(accessoryView)
        accessoryView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(32)
        }
    }
}
