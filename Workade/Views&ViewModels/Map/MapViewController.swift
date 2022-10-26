//
//  MapViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/23.
//

import NMapsMap
import UIKit

class MapViewController: UIViewController {
    //Binding 객체
    var latitude = 33.533054
    var longitude = 126.630947
    var officeName = "제주 O-PEACE"
    
    init(latitude: Double, longitude: Double, officeName: String) {
        super.init(nibName: nil, bundle: nil)
        self.latitude = latitude
        self.longitude = longitude
        self.officeName = officeName
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var map = NMFMapView()
    private var topInfoStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private lazy var officeNameLabel: BasePaddingLabel = {
        var label = BasePaddingLabel(padding: UIEdgeInsets(top: 12, left: 40, bottom: 12, right: 40))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.officeName
        label.textAlignment = .center
        label.backgroundColor = .theme.background
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.font = UIFont.customFont(for: .subHeadline)
        
        return label
    }()
    
    private lazy var backButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(xmarkImage, for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Pro Rounded", size: 17)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonDown), for: .touchDown)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNMap()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(map)
        
        view.addSubview(topInfoStackView)
        NSLayoutConstraint.activate([
            topInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topInfoStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
        
        setupTopInfoViewLayout()
    }
    
    private func setupTopInfoViewLayout() {
        topInfoStackView.addSubview(officeNameLabel)
        NSLayoutConstraint.activate([
            officeNameLabel.centerXAnchor.constraint(equalTo: topInfoStackView.centerXAnchor),
            officeNameLabel.centerYAnchor.constraint(equalTo: topInfoStackView.centerYAnchor)
        ])
        
        topInfoStackView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topInfoStackView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: topInfoStackView.bottomAnchor),
            backButton.trailingAnchor.constraint(equalTo: topInfoStackView.trailingAnchor, constant: -20),
            backButton.leadingAnchor.constraint(equalTo: topInfoStackView.leadingAnchor, constant: UIScreen.main.bounds.width - 64)
        ])
    }
    
    @objc private func backButtonDown() {
        var cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        map.moveCamera(cameraUpdate)
    }
}

//지도에 관한 Extention입니다.
extension MapViewController {
    private func setupNMap() {
        map.frame = view.frame
        setCameraMap()
        setMarkOfficePlace()
    }
    
    private func setCameraMap() {
        var cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        map.moveCamera(cameraUpdate)
    }
    
    private func setMarkOfficePlace() {
        let officeMarker = NMFMarker()
        
        officeMarker.position = NMGLatLng(lat: latitude, lng: longitude)
        officeMarker.captionText = officeName
        
        let closure: (NMFOverlay) -> Bool = { overlay in
            print("Heeloooo")
            return true
        }
        officeMarker.touchHandler = closure
        
        let officeInfo = NMFInfoWindow()
        let officeSource = NMFInfoWindowDefaultTextSource.data()
        officeSource.title = "누르면 나오는 정보"
        officeInfo.dataSource = officeSource
        
        officeInfo.open(with: officeMarker)

        
        officeMarker.mapView = map
        
        map.touchDelegate = self
        
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(point.debugDescription)
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol.debugDescription)
        return true
    }
}
