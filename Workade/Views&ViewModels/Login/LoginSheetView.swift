//
//  LoginModalViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/21.
//

import UIKit

class LoginSheetView: UIView {
    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "workationlogo")
        logo.contentMode = .scaleAspectFit
        
        return logo
    }()
    
    private let guideLabel: UILabel = {
        let guide = UILabel()
        guide.translatesAutoresizingMaskIntoConstraints = false
        guide.setLineHeight(lineHeight: 6)
        guide.text = "간편하게 SNS로 로그인하고\n워케이션을 더 즐겁게 보내봐요"
        guide.textAlignment = .center
        guide.numberOfLines = 0
        guide.textColor = .black
        guide.font = .customFont(for: .subHeadline)
        
        return guide
    }()
    
    lazy var closeButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .default)
        let button = UIButton()
        
        button.tintColor = .theme.tertiary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .theme.groupedBackground
        button.layer.cornerRadius = 14
        button.addAction(UIAction { [weak self] _ in
            self?.parentViewController?.dismiss(animated: true)
        }, for: .touchUpInside)
        
        guard let image = UIImage(systemName: "xmark", withConfiguration: config) else { return button }
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    lazy var appleLoginButton: LoginButtonView = {
        let loginButton = LoginButtonView(logo: UIImage(named: "applelogo"), loginCase: .apple)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }()
    
    lazy var googleLoginButton: LoginButtonView = {
        let loginButton = LoginButtonView(logo: UIImage(named: "googlelogo"), loginCase: .google)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }()
    
    private let region: Region?
    
    init(region: Region?) {
        self.region = region
        super.init(frame: .zero)
        layer.cornerRadius = 30
        backgroundColor = .theme.background
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            guideLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 36.5)
        ])
        
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            closeButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50), // -(22 + 28)
            closeButton.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 48) // 20 + 28
        ])
        
        let googleTabGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoogleLogin))
        googleLoginButton.addGestureRecognizer(googleTabGesture)
        addSubview(googleLoginButton)
        NSLayoutConstraint.activate([
            googleLoginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            googleLoginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let appleTabGesture = UITapGestureRecognizer(target: self, action: #selector(handleAppleLogin))
        appleLoginButton.addGestureRecognizer(appleTabGesture)
        addSubview(appleLoginButton)
        NSLayoutConstraint.activate([
            appleLoginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            appleLoginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: 0),
            appleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func handleAppleLogin() {
        FirebaseManager.shared.touchUpAppleButton(region: region, appleSignupCompletion: {[weak self] in
            self?.parentViewController?.navigationController?.pushViewController(LoginNameViewController(region: self?.region), animated: true)
        },
                                                  appleSigninCompletion: { [weak self] in
            self?.parentViewController?.navigationController?.dismiss(animated: true)
        })
    }
    
    @objc func handleGoogleLogin() {
        FirebaseManager.shared.touchUpGoogleButton(region: region,
                                                   signupCompletion: { [weak self] in
            self?.parentViewController?.navigationController?.pushViewController(LoginNameViewController(region: self?.region), animated: true)
        },
                                                   signinCompletion: { [weak self] in
            self?.parentViewController?.navigationController?.dismiss(animated: true)
        }
        )
    }
}
