//
//  PlaceImageView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/10.
//

import UIKit

// BaseImageView -> CloseButton / CustomNavigationBar -> locationLabel -> placeLabel -> mapButton
class NearbyPlaceImageView: UIView {
    let office: Office
    weak var delegate: InnerTouchPresentDelegate?
    
    // MARK: Property 선언
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = UIFont.customFont(for: .title3)
        locationLabel.textColor = .theme.background
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return locationLabel
    }()
    
    private let placeLabel: UILabel = {
        let placeLabel = UILabel()
        placeLabel.font = UIFont.customFont(for: .title1)
        placeLabel.textColor = .theme.background
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return placeLabel
    }()
    
    lazy var mapButton: UIButton = {
        let mapButton = UIButton()
        let blur = UIVisualEffectView(effect:
                                        UIBlurEffect(style: UIBlurEffect.Style.light))
        mapButton.frame.size = CGSize(width: 48, height: 48)
        mapButton.layer.cornerRadius = mapButton.bounds.height / 2
        mapButton.setImage(SFSymbol.map.image, for: .normal)
        
        blur.frame = mapButton.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = 0.5 * mapButton.bounds.size.height
        blur.clipsToBounds = true
        mapButton.insertSubview(blur, belowSubview: mapButton.imageView ?? UIImageView())
        mapButton.addTarget(self, action: #selector(clickedMapButton), for: .touchUpInside)
        
        return mapButton
    }()
    
    let mapButtonContainer: UIView = {
        let mapButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        mapButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return mapButtonContainer
    }()
    
    init(office: Office) {
        self.office = office
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setupOfficeData()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupOfficeData() {
        placeLabel.text = office.officeName
        locationLabel.text = office.regionName
        Task {
            await imageView.setImageURL(office.imageURL)
        }
    }
    
    // AutoLayout
    private func setupLayout() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        imageView.addSubview(placeLabel)
        NSLayoutConstraint.activate([
            placeLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            placeLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20)
        ])
        
        imageView.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.bottomAnchor.constraint(equalTo: placeLabel.topAnchor, constant: -5),
            locationLabel.leadingAnchor.constraint(equalTo: placeLabel.leadingAnchor)
        ])
        
        addSubview(mapButtonContainer)
        NSLayoutConstraint.activate([
            mapButtonContainer.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -17),
            mapButtonContainer.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -17)
        ])
        
        mapButtonContainer.addSubview(mapButton)
        NSLayoutConstraint.activate([
            mapButton.centerXAnchor.constraint(equalTo: mapButtonContainer.centerXAnchor),
            mapButton.centerYAnchor.constraint(equalTo: mapButtonContainer.centerYAnchor)
        ])
    }
    
    // Button 클릭 관련 함수
    @objc
    func clickedMapButton() {
        delegate?.touch(office: self.office)
    }
}
