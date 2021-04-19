//
//  TreeAnnotationView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 11.04.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class TreeAnnotationView: UIView {
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 48
        return size
    }
    
    // MARK: Frame
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()

    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func configure(with state: TreeAnnotationState) {
        switch state {
        case .hidden:
            animateAppearance(false)
        case .visible(let data):
            isHidden = false
            titleLabel.text = data.title
            moreButton.setTitle(data.buttonText, for: .normal)
            animateAppearance(true)
        }
    }
    
    
    // MARK: Private
    
    private func animateAppearance(_ appear: Bool) {
        UIView.animate(withDuration: .appearanceDuration) {
            self.alpha = appear ? 1 : 0
        }
    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.right.lessThanOrEqualToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).inset(-8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}


extension Reactive where Base == TreeAnnotationView {
    
    var tap: ControlEvent<Void> {
        base.moreButton.rx.tap
    }
    
    var configuration: Binder<TreeAnnotationState> {
        Binder(self.base) { view, state in
            view.configure(with: state)
        }
    }
}


private extension TimeInterval {
    
    static let appearanceDuration: TimeInterval = 0.2
}
