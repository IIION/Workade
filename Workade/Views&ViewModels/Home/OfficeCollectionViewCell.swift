//
//  OfficeCollectionViewCell.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

class OfficeCollectionViewCell: UICollectionViewCell {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .theme.groupedBackground // Skeleton color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let mapButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let image = UIImage(systemName: "map", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 18
        button.layer.backgroundColor = UIColor.black.withAlphaComponent(0.1).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let regionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .subHeadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let officeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .title3)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(office: Office) {
        // 추후 image는 Task{ } 블럭에서 처리예정.
        backgroundImageView.image = office.profileImage
        regionNameLabel.text = office.regionName
        officeNameLabel.text = office.officeName
    }
}

// MARK: UI setup 관련 Methods
extension OfficeCollectionViewCell {
    private func setupLayer() {
        self.layer.cornerRadius = 12
    }
    
    private func setupLayout() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(mapButton)
        contentView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(regionNameLabel)
        titleStackView.addArrangedSubview(officeNameLabel)
        
        let backgroundImageViewConstraints = [
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        
        let mapButtonConstraints = [
            mapButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mapButton.widthAnchor.constraint(equalToConstant: 36),
            mapButton.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        let stackViewConstraints = [
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(backgroundImageViewConstraints)
        NSLayoutConstraint.activate(mapButtonConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
    }
}
