//
//  LoginButtonView.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

enum LoginCase: String {
    case apple
    case google
    
    var name: String {
        switch self {
        case .apple:
            return "Apple"
        case .google:
            return "Google"
        }
    }
}

final class LoginButtonView: UIView {
    var logoImage: UIImage?
    var loginCase: LoginCase
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        return textLabel
    }()
    
    init(logo: UIImage?, loginCase: LoginCase) {
        self.logoImage = logo
        self.loginCase = loginCase
        super.init(frame: .zero)
        
        layer.cornerRadius = 12
        backgroundColor = loginCase == .apple ? .theme.primary : .theme.groupedBackground
        textLabel.textColor = loginCase == .apple ? .theme.background : .theme.primary
        
        setData()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 24),
            logoImageView.heightAnchor.constraint(equalToConstant: 24),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setData() {
        logoImageView.image = logoImage
        textLabel.text = loginCase.name + "로 로그인"
    }
}
