//
//  LoginInformationView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/21.
//

import UIKit

class LoginInformationView: UIView {
    private let loginInformationLabel: UILabel = {
        let loginInformationLabel = UILabel()
        loginInformationLabel.text = "로그인 정보"
        loginInformationLabel.font = .customFont(for: .captionHeadlineNew)
        loginInformationLabel.textColor = .theme.primary
        loginInformationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return loginInformationLabel
    }()
    
    let eMailLabel: UILabel = {
        let eMailLabel = UILabel()
        eMailLabel.font = .customFont(for: .footnote)
        eMailLabel.textColor = .theme.primary
        eMailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return eMailLabel
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .theme.primary
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.theme.background, for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .customFont(for: .subHeadline)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(loginInformationLabel)
        NSLayoutConstraint.activate([
            loginInformationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            loginInformationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        addSubview(eMailLabel)
        NSLayoutConstraint.activate([
            eMailLabel.topAnchor.constraint(equalTo: loginInformationLabel.bottomAnchor, constant: 4),
            eMailLabel.leadingAnchor.constraint(equalTo: loginInformationLabel.leadingAnchor)
        ])
        
        addSubview(logOutButton)
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            logOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            logOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            logOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
