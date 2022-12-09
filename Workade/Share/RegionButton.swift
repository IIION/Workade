//
//  LocationButton.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/22.
//

import UIKit

final class RegionButton: UIButton {
    let region: Region
    weak var selectedRegion: Binder<Region?>?
    var peopleCount: Int {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.peopleCountLabel.text = "\(self!.peopleCount)"
            }
        }
    }
    
    private lazy var regionLabel: UILabel = {
        let label = UILabel()
        label.text = self.region.name
        label.font = .customFont(for: .footnote2)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let peopleImage: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 9, weight: .regular, scale: .default)
        
        let peopleImage = UIImageView()
        peopleImage.image = UIImage(systemName: "person.fill", withConfiguration: config)
        peopleImage.tintColor = .theme.primary
        peopleImage.isUserInteractionEnabled = false
        peopleImage.translatesAutoresizingMaskIntoConstraints = false
        
        return peopleImage
    }()
    
    private lazy var peopleCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.font = .customFont(for: .caption2)
        label.text = "\(peopleCount)"
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    init(region: Region, selectedRegion: Binder<Region?>, peopleCount: Int) {
        self.region = region
        self.selectedRegion = selectedRegion
        self.peopleCount = peopleCount
        
        super.init(frame: .zero)
        setupLayout()
        
        self.addAction(UIAction(handler: { [weak self] _ in
            if let selectRegion = selectedRegion.value, selectRegion == region {
                self?.selectedRegion?.value = nil
            } else {
                self?.selectedRegion?.value = self?.region
            }
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .theme.background
        layer.borderColor = UIColor.theme.workadeBlue.cgColor
        
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
        layer.borderWidth = selectedRegion?.value == nil ? 1 : 0
        if let selectRegion = selectedRegion?.value, selectRegion == region {
            backgroundColor = .theme.primary
            regionLabel.textColor = .theme.background
            peopleCountLabel.textColor = .theme.background
            peopleImage.tintColor = .theme.background
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } else {
            backgroundColor = .theme.background
            regionLabel.textColor = .theme.primary
            peopleCountLabel.textColor = .theme.primary
            peopleImage.tintColor = .theme.primary
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
