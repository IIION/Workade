//
//  TipDetailCell.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/21.
//

import UIKit

class TipDetailCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.background
        label.font = .customFont(for: .headline)
        // Temp
        label.text = "내 성격에 맞는\n장소 찾는 법"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .theme.background
        
        return button
    }()
    
    private let cellBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Temp
        imageView.image = UIImage(named: "SampleTipImage") ?? UIImage()
        
        return imageView
    }()
    
    private let opacityOfImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .theme.primary
        view.alpha = CGFloat(0.1)
        view.layer.cornerRadius = 13.2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 13.2
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayout() {
        contentView.addSubview(cellBackgroundImage)
        NSLayoutConstraint.activate([
            cellBackgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellBackgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            cellBackgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cellBackgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        contentView.addSubview(opacityOfImageView)
        NSLayoutConstraint.activate([
            opacityOfImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            opacityOfImageView.topAnchor.constraint(equalTo: self.topAnchor),
            opacityOfImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            opacityOfImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        contentView.addSubview(bookMarkButton)
        NSLayoutConstraint.activate([
            bookMarkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            bookMarkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        ])
    }
}
