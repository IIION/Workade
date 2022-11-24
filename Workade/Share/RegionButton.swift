//
//  LocationButton.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/22.
//

import UIKit

class RegionButton: UIButton {
    var region: RegionModel
    weak var selectedRegion: Binder<RegionModel?>?
    let peopleCount: Int
    
    private lazy var regionLabel: UILabel = {
        let label = UILabel()
        label.text = self.region.name
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
        setupLayout()
        
        self.addAction(UIAction(handler: { [weak self] _ in
            self?.selectedRegion?.value = self?.region
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .theme.background
        regionLabel.textColor = .theme.primary
        let sizeConstant: CGFloat = 64
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: sizeConstant),
            heightAnchor.constraint(equalToConstant: sizeConstant)
        ])
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = sizeConstant / 2
        
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
        changeLayout()
    }
    
    func changeLayout() {
        if let selectedRegion = selectedRegion?.value {
            layer.borderWidth = 0
            if selectedRegion == region {
                backgroundColor = .theme.primary
                regionLabel.textColor = .theme.background
                peopleCountLabel.textColor = .theme.background
                peopleImage.tintColor = .theme.background
            } else {
                backgroundColor = .theme.background
                regionLabel.textColor = .theme.primary
                peopleCountLabel.textColor = .theme.primary
                peopleImage.tintColor = .theme.primary
            }
        } else {
            backgroundColor = .theme.background
            regionLabel.textColor = .theme.primary
            peopleCountLabel.textColor = .theme.primary
            peopleImage.tintColor = .theme.primary
            layer.borderWidth = 1
            layer.borderColor = UIColor.theme.workadeBlue.cgColor
        }
    }
}
