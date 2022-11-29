//
//  LoginNextButtonView.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/23.
//

import UIKit

class LoginNextButtonView: UIView {
    private let tapGesture: () -> Void
    private let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
        imageView.image = UIImage(systemName: "greaterthan", withConfiguration: config)
        
        return imageView
    }()
    
    private let guideLabel: UILabel = {
        let guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.text = "가입하기"
        guideLabel.font = .customFont(for: .subHeadline)
        guideLabel.textColor = .theme.background
        
        return guideLabel
    }()
    
    init(tapGesture: @escaping () -> Void) {
        self.tapGesture = tapGesture
        super.init(frame: .zero)
        
        layer.cornerRadius = 24
        tintColor = .white
        
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(nextImageView)
        NSLayoutConstraint.activate([
            nextImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nextImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            guideLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
        guideLabel.isHidden = true
    }
    
    func readyToSignup(isReady: Bool) {
        guideLabel.isHidden = !isReady
        isUserInteractionEnabled = isReady
        backgroundColor = isReady ? .blue : .gray
    }
    
    @objc func handleTapGesture() {
        tapGesture()
    }
}
