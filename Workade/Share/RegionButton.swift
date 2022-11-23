//
//  LocationButton.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/22.
//

import UIKit

class RegionButton: UIButton {
    var region: RegionModel
    var selectedRegion: Binder<RegionModel?>
    let peopleCount: Int
    
    private lazy var regionLabel: UILabel = {
        let label = UILabel()
        label.text = self.region.rawValue
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
    
    init(region: RegionModel, selectedRegion: Binder<RegionModel?>, peopleCount: Int) {
        self.region = region
        self.selectedRegion = selectedRegion
        self.peopleCount = peopleCount
        
        super.init(frame: .zero)
        if selectedRegion.value == region {
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
        
        addSubview(regionLabel)
        NSLayoutConstraint.activate([
            regionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            regionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: regionLabel.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupSelectLayout() {
        setupButtonScale(scale: 72)
        
        addSubview(regionLabel)
        NSLayoutConstraint.activate([
            regionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            regionLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupButtonScale(scale: CGFloat) {
        layer.cornerRadius = scale / 2
        
        if scale == 64 {
            backgroundColor = .theme.background
            regionLabel.textColor = .theme.primary
            
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: scale),
                heightAnchor.constraint(equalToConstant: scale)
            ])
        } else {
            backgroundColor = .theme.primary
            regionLabel.textColor = .theme.background
            
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: scale),
                heightAnchor.constraint(equalToConstant: scale)
            ])
        }
    }
}
