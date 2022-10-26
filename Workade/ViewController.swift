//
//  ViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

class LaunchScreenAnimationView: UIView {
    lazy var logoView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "WorkadeLogoTamna")!)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var backgroundView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "GalleryTestImage2")!)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.addSubview(backgroundView)
        self.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -120),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        var aspectR: CGFloat = 1
        if let image = logoView.image {
            print(image.size.width)
            print(image.size.height)
            aspectR = image.size.width / image.size.height
        }
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 120),
            logoView.heightAnchor.constraint(equalToConstant: 120, multiplier: 1 / aspectR)
        ])
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
