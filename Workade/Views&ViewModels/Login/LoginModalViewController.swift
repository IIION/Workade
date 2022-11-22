//
//  LoginModalViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/21.
//

import UIKit

class LoginModalViewController: UIViewController {
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
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        view.addSubview(guideLable)
        NSLayoutConstraint.activate([
            guideLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideLable.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 36.5)
        ])
        
        closeButton.addAction(UIAction{ [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            closeButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50), // -(22 + 28)
            closeButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 48) // 20 + 28
        ])
        
        let appleTabGesture = UITapGestureRecognizer(target: self, action: #selector(handleAppleLogin))
        appleLoginButton.addGestureRecognizer(appleTabGesture)
        view.addSubview(appleLoginButton)
        NSLayoutConstraint.activate([
            appleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 173),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleLoginButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 280)
        ])
        
        let googleTabGesture = UITapGestureRecognizer(target: self, action: #selector(handleGoogleLogin))
        googleLoginButton.addGestureRecognizer(googleTabGesture)
        view.addSubview(googleLoginButton)
        NSLayoutConstraint.activate([
            googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 173),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            googleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            googleLoginButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 280)
        ])
    }
    
    @objc func handleAppleLogin() {
        print("Apple Login")
     }
    
    @objc func handleGoogleLogin() {
        print("Google Login")
    }
}
