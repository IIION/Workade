//
//  LoginView.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/21.
//

import UIKit

class  LoginView: UIView {
    var buttonAction: UIAction
    private let guideLabel: UILabel = {
        let guidance = UILabel()
        guidance.text = "워케이션을 즐기고\n다양한 스티커를 얻어보세요"
        guidance.setLineHeight(lineHeight: 10)
        guidance.font = .customFont(for: .captionHeadlineNew)
        guidance.textAlignment = .center
        guidance.translatesAutoresizingMaskIntoConstraints = false
        guidance.numberOfLines = 0
        guidance.textColor = .theme.background
        
        return guidance
    }()
    
    private let loginImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "loginimage")
        image.sizeToFit()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let loginButtonView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 6
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let umbrellaImageView: UIImageView = {
        let umbrellaImage = UIImageView()
        umbrellaImage.translatesAutoresizingMaskIntoConstraints = false
        umbrellaImage.image = UIImage(systemName: "beach.umbrella.fill")
        umbrellaImage.tintColor = .theme.background
        
        return umbrellaImage
    }()
    
    private let loginButtonText: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = "나도 같이 동참하기"
        textLabel.textColor = .theme.background
        textLabel.font = .customFont(for: .subHeadline)
        
        return textLabel
    }()
    
    lazy var loginButton: UIButton = {
       let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        loginButton.addAction(buttonAction, for: .touchUpInside)
        loginButton.layer.cornerRadius = 30
        loginButton.backgroundColor = .black
        
        return loginButton
    }()
    
    init(action: UIAction) {
        self.buttonAction = action
        super.init(frame: .zero)
        backgroundColor = .blue
        layer.cornerRadius = 32
        
        setupLayout()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            guideLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        addSubview(loginImage)
        NSLayoutConstraint.activate([
            loginImage.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 38.02),
            loginImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: loginImage.bottomAnchor, constant: 38.02),
            loginButton.widthAnchor.constraint(equalToConstant: 204),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        loginButton.addSubview(loginButtonView)
        NSLayoutConstraint.activate([
            loginButtonView.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            loginButtonView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor)
        ])
        loginButtonView.isUserInteractionEnabled = false
        
        loginButtonView.addArrangedSubview(umbrellaImageView)
        NSLayoutConstraint.activate([
            umbrellaImageView.heightAnchor.constraint(equalToConstant: 18),
            umbrellaImageView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        loginButtonView.addArrangedSubview(loginButtonText)
    }
    
    private func setButtonAction() {
        loginButton.addAction(buttonAction, for: .touchUpInside)
    }
}
