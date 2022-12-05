//
//  ProfileView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/16.
//

import UIKit

class ProfileView: UIView {
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 32
        imageView.backgroundColor = .theme.groupedBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
                
        return imageView
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.theme.tertiary, for: .normal)
        button.titleLabel?.font = .customFont(for: .caption2)
        button.backgroundColor = .theme.labelBackground
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        containerView.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 64),
            profileImage.heightAnchor.constraint(equalToConstant: 64),
            profileImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            profileImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)
        ])
        
        containerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20)
        ])
        
        containerView.addSubview(jobLabel)
        NSLayoutConstraint.activate([
            jobLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 20)
        ])
        
        containerView.addSubview(editProfileButton)
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: profileImage.topAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            editProfileButton.widthAnchor.constraint(equalToConstant: 90),
            editProfileButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20).isActive = true
    }
}
