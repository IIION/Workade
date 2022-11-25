//
//  NearbyPlaceDetailView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/10.
//

import UIKit

class NearbyPlaceDetailView: UIView {
    let officeModel: OfficeModel
    var introduceViewModel: IntroduceViewModel
    
    var mapVC: MapViewController?
    var introduceBottomConstraints: NSLayoutConstraint!
    var galleryBottomConstraints: NSLayoutConstraint!
    var featureBottomConstraints: NSLayoutConstraint!
    var mapBottomConstrains: NSLayoutConstraint!
    
    let contensContainerView: UIView = {
        let contensContainerView = UIView()
        contensContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        return contensContainerView
    }()
    
    let introduceView: IntroduceView = {
        let view = IntroduceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let galleryView: GalleryView = {
        let view = GalleryView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var featureView: FeatureView!
    
    var mapView: UIView!
    
    init(officeModel: OfficeModel) {
        self.officeModel = officeModel
        self.introduceViewModel = IntroduceViewModel()
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setFeatureView()
        setupMapView()
        setupViewBottomConstraints()
        setupIntroduceView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFeatureView() {
        featureView = FeatureView(officeFeature: officeModel.feature)
        featureView.isHidden = true
        featureView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupMapView() {
        mapVC = MapViewController(office: officeModel)
        mapVC?.setMapCamera()
        
        mapView = mapVC?.view
        mapView.isHidden = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViewBottomConstraints() {
        introduceBottomConstraints = introduceView.bottomAnchor.constraint(equalTo: contensContainerView.bottomAnchor, constant: -20)
        galleryBottomConstraints = galleryView.bottomAnchor.constraint(equalTo: contensContainerView.bottomAnchor, constant: -20)
        featureBottomConstraints = featureView.bottomAnchor.constraint(equalTo: contensContainerView.bottomAnchor, constant: -20)
        mapBottomConstrains = mapView.bottomAnchor.constraint(equalTo: contensContainerView.bottomAnchor)
    }
    
    func setupLayout() {
        addSubview(contensContainerView)

        NSLayoutConstraint.activate([
            contensContainerView.topAnchor.constraint(equalTo: topAnchor),
            contensContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contensContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contensContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contensContainerView.addSubview(introduceView)
        NSLayoutConstraint.activate([
            introduceView.topAnchor.constraint(equalTo: contensContainerView.topAnchor, constant: 20),
            introduceView.leadingAnchor.constraint(equalTo: contensContainerView.leadingAnchor, constant: 20),
            introduceView.trailingAnchor.constraint(equalTo: contensContainerView.trailingAnchor, constant: -20),
            introduceBottomConstraints
        ])
        
        contensContainerView.addSubview(featureView)
        NSLayoutConstraint.activate([
            featureView.topAnchor.constraint(equalTo: contensContainerView.topAnchor, constant: 30),
            featureView.leadingAnchor.constraint(equalTo: contensContainerView.leadingAnchor, constant: 20),
            featureView.trailingAnchor.constraint(equalTo: contensContainerView.trailingAnchor, constant: -20),
            featureView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - .topSafeArea - 52)
        ])
        
        contensContainerView.addSubview(galleryView)
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: contensContainerView.topAnchor, constant: 0),
            galleryView.leadingAnchor.constraint(equalTo: contensContainerView.leadingAnchor, constant: 0),
            galleryView.trailingAnchor.constraint(equalTo: contensContainerView.trailingAnchor, constant: 0),
            galleryView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - .topSafeArea - 52)
        ])
        
        contensContainerView.addSubview(mapView)
        // 네비게이션 바 높이 = 60으로 고정값임. 디바이스별로 구분할 필요 없음.
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contensContainerView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: contensContainerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contensContainerView.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - .topSafeArea - 52 - 60)
        ])
    }
}

extension NearbyPlaceDetailView {
    /// introduce 소개 글을 불러오는 fetch함수
    private func setupIntroduceView() {
        introduceViewModel.requestOfficeDetailData(from: officeModel.introduceURL)
        introduceViewModel.introductions.bind { [weak self] contents in
            guard let self = self else { return }
            for content in contents {
                switch content.type {
                case "Text":
                    let label = UILabel()
                    label.text = content.content
                    if let font = content.font {
                        label.font = .customFont(for: CustomTextStyle(rawValue: font) ?? .articleBody)
                    }
                    if let color = content.color {
                        label.textColor = UIColor(named: color)
                    }
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 0
                    label.setLineHeight(lineHeight: 12.0)
                    self.introduceView.stackView.addArrangedSubview(label)
                case "Image":
                    let imageView = UIImageView()
                    let imageURL = content.content
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    Task {
                        do {
                            let image = try await NetworkManager.shared.fetchImage(from: imageURL)
                            imageView.image = image
                            let width = image.size.width
                            let height = image.size.height
                            
                            imageView.contentMode = .scaleToFill
                            imageView.layer.cornerRadius = 20
                            imageView.clipsToBounds = true
                            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: height/width).isActive = true
                        } catch {
                            let error = error as? NetworkError ?? .unknownError
                            print(error.message)
                        }
                    }
                    self.introduceView.stackView.addArrangedSubview(imageView)
                default:
                    continue
                }
            }
        }
    }
}
