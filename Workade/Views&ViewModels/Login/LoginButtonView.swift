//
//  LoginButtonView.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

final class LoginButtonView: UIView {
    var logoImage: UIImage?
    var guideance: String
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return logoImageView
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .customFont(for: .footnote2) // TODO: footnote2New 부재
        textLabel.textColor = .black
        
        return textLabel
    }()
    
    init(logo: UIImage?, guideance: String) {
        self.logoImage = logo
        self.guideance = guideance
        super.init(frame: .zero)
        
        layer.cornerRadius = 20
        backgroundColor = .theme.groupedBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        logoImageView.image = logoImage
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 24),
            logoImageView.heightAnchor.constraint(equalToConstant: 24),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 22.5)
        ])
        
        textLabel.text = guideance
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
