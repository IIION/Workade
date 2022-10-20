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
    
    private lazy var regionLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .subHeadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .title3)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
}
