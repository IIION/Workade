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
        
        return logo
    }()
    
    private let guideLable: UILabel = {
        let guide = UILabel()
        guide.translatesAutoresizingMaskIntoConstraints = false
        guide.setLineHeight(lineHeight: 6)
        guide.text = "간편하게 SNS로 로그인하고\n워케이션을 더 즐겁게 보내봐요"
        guide.textAlignment = .center
        guide.numberOfLines = 0
        guide.textColor = .black
        guide.font = .customFont(for: .subHeadline) // TODO: SubheadlineNEW ?? 가 폰트에 없다.
        
        return guide
    }()
    
    lazy var closeButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .default)
        
        let button = UIButton()
        
        button.tintColor = .theme.tertiary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .theme.groupedBackground
        button.layer.cornerRadius = 14
        
        return button
    }()
    
    lazy var appleLoginButton: LoginButtonView = {
        let loginButton = LoginButtonView(logo: UIImage(named: "applelogo"), guideance: "Apple로 게속하기")
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }()
    
    lazy var googleLoginButton: LoginButtonView = {
        let loginButton = LoginButtonView(logo: UIImage(named: "googlelogo"), guideance: "Google로 계속하기")
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }()
    
    private var handleCloseButton: () -> Void
    
    init(handleCloseButton: @escaping () -> Void) {
        self.handleCloseButton = handleCloseButton
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
        
        addSubview(guideLable)
        NSLayoutConstraint.activate([
            guideLable.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            guideLable.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 36.5)
        ])
        
        closeButton.addAction(UIAction { [weak self] _ in
            UIView.animate(withDuration: 0.3) {
                self?.handleCloseButton()
            }
        }, for: .touchUpInside)
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            closeButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50), // -(22 + 28)
            closeButton.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 48) // 20 + 28
        ])
        
        let appleTabGesture = UITapGestureRecognizer(target: self, action: #selector(handleAppleLogin))
        appleLoginButton.addGestureRecognizer(appleTabGesture)
        addSubview(appleLoginButton)
        NSLayoutConstraint.activate([
            appleLoginButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 173),
            appleLoginButton.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -6),
            appleLoginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            appleLoginButton.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 280)
        ])
        
        let googleTabGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoogleLogin))
        googleLoginButton.addGestureRecognizer(googleTabGesture)
        addSubview(googleLoginButton)
        NSLayoutConstraint.activate([
            googleLoginButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 173),
            googleLoginButton.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 6),
            googleLoginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            googleLoginButton.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 280)
        ])
    }
    
    @objc func handleAppleLogin() {
        FirebaseManager.shared.touchUpAppleButton {
        }
     }
    
    @objc func handleGoogleLogin() {
//        FirebaseManager.shared.isUserLogin()
        FirebaseManager.shared.touchUpGoogleButton {
        }
    }
}
