//
//  LocationButton.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/22.
//

import UIKit

class LocationButton: UIButton {
    var region: String
    var selectedRegion: Binder<Region?>
    let peopleCount: Int
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = self.region
        label.font = .customFont(for: .footnote2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let peopleImage: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 9, weight: .regular, scale: .default)
        
        let peopleImage = UIImageView()
        peopleImage.image = UIImage(systemName: "person.fill", withConfiguration: config)
        peopleImage.tintColor = .theme.primary
        peopleImage.translatesAutoresizingMaskIntoConstraints = false
        
        return peopleImage
    }()
    
    private lazy var peopleCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.font = .customFont(for: .caption2)
        label.text = "\(peopleCount)"
        
        return label
    }()
    
    init(region: String, selectedRegion: Binder<Region?>, peopleCount: Int) {
        self.region = region
        self.selectedRegion = selectedRegion
        self.peopleCount = peopleCount
        
        super.init(frame: .zero)
        if selectedRegion.value?.rawValue == region {
            setupSelectLayout()
        } else {
            setupBasicLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBasicLayout() {
        setupButtonScale(scale: 64)
        stackView.addArrangedSubview(peopleImage)
        stackView.addArrangedSubview(peopleCountLabel)
        
        addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupSelectLayout() {
        setupButtonScale(scale: 72)
        
        addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupButtonScale(scale: CGFloat) {
        layer.cornerRadius = scale / 2
        
        if scale == 64 {
            backgroundColor = .theme.background
            locationLabel.textColor = .theme.primary
            
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: scale),
                heightAnchor.constraint(equalToConstant: scale)
            ])
        } else {
            backgroundColor = .theme.primary
            locationLabel.textColor = .theme.background
            
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: scale),
                heightAnchor.constraint(equalToConstant: scale)
            ])
        }
    }
}
