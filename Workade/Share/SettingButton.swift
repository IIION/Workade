//
//  SettingButton.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/21.
//

import UIKit

final class SettingButton: UIButton {
    private let text: String
    
    private lazy var titleText: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .headline)
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var chevronView: UIImageView = {
        let imageView = UIImageView(image: SFSymbol.chevronRight.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.theme.groupedBackground.cgColor
        layer.cornerRadius = 15
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleText)
        addSubview(chevronView)
        
        NSLayoutConstraint.activate([
            titleText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleText.topAnchor.constraint(equalTo: topAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            chevronView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
