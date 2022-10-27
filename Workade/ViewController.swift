//
//  ViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

class LaunchScreenAnimationView: UIView {
    
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
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 120),
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
        let animator = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut)
        let endAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        animator.addAnimations({
            self.backgroundView.frame.origin.x = 120
        }, delayFactor: 0.2)
        
        animator.addCompletion { _ in
            endAnimator.startAnimation(afterDelay: 0.2)
        }
        
        endAnimator.addAnimations {
            self.backgroundView.alpha = 0
            self.logoView.alpha = 0
        }
        
        endAnimator.addCompletion { _ in
            self.isHidden = true
        }
        
        animator.startAnimation()
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .blue
        setupLayout()
    }
    
    lazy var launchScreenView: LaunchScreenAnimationView = {
        let view = LaunchScreenAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setupLayout() {
        self.view.addSubview(launchScreenView)
        
        NSLayoutConstraint.activate([
            launchScreenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            launchScreenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            launchScreenView.topAnchor.constraint(equalTo: self.view.topAnchor),
            launchScreenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
