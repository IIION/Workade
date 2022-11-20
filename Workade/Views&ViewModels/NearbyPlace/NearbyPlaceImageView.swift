//
//  PlaceImageView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/10.
//

import UIKit

// BaseImageView -> CloseButton / CustomNavigationBar -> locationLabel -> placeLabel -> mapButton
class NearbyPlaceImageView: UIView {
    let officeModel: OfficeModel
    
    // MARK: Property 선언
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let placeLabel = UILabel()
        placeLabel.font = UIFont.customFont(for: .title1)
        placeLabel.textColor = .theme.background
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return placeLabel
    }()
    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = UIFont.customFont(for: .footnote)
        locationLabel.textColor = .theme.background
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return locationLabel
    }()
    
    init(officeModel: OfficeModel) {
        self.officeModel = officeModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setupOfficeData()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupOfficeData() {
        placeLabel.text = officeModel.officeName
        locationLabel.text = officeModel.regionName
        Task {
            do {
                try await imageView.setImageURL(from: officeModel.imageURL)
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    // AutoLayout
    private func setupLayout() {
        addSubview(imageView)
        
        imageView.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            locationLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20)
        ])
        
        imageView.addSubview(placeLabel)
        NSLayoutConstraint.activate([
            placeLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -5),
            placeLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor)
        ])
    }
}
