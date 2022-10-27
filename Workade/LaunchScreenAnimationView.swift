//
//  LaunchScreenAnimationView.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/28.
//

import UIKit

protocol LaunchScreenTimingDelegate: AnyObject {
    func finishLaunchScreen()
}

class LaunchScreenAnimationView: UIView {
    
    weak var delegate: LaunchScreenTimingDelegate?
    
    lazy var backgroundView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "launch")!)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var logoView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "iconTransperent")!)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.alpha = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        showAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.addSubview(backgroundView)
        self.addSubview(dimmingView)
        self.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dimmingView.topAnchor.constraint(equalTo: self.topAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            logoView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 160),
            logoView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func showAnimation() {
        let animator = UIViewPropertyAnimator(duration: 1.8, curve: .easeInOut)
        let endAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        animator.addAnimations({
            self.backgroundView.frame.origin.x = 40
        }, delayFactor: 0.4)
        
        animator.addCompletion { _ in
            endAnimator.startAnimation(afterDelay: 0.2)
        }
        
        endAnimator.addAnimations {
            self.backgroundView.alpha = 0
            self.logoView.alpha = 0
        }
        
        endAnimator.addCompletion { _ in
            self.isHidden = true
            self.delegate?.finishLaunchScreen()
        }
        
        animator.startAnimation()
    }
}
