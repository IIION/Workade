//
//  MapViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/23.
//

import NMapsMap
import UIKit

class MapViewController: UIViewController {
    // Binding 객체
    var latitude = 33.533054
    var longitude = 126.630947
    var officeName = "제주 O-PEACE"
    // 임시 설정 주변 정보
    var nearbyPlaces = [
        [
          "title": "폴스키친",
          "latitude": 33.5352183,
          "longitude": 126.6279621,
          "type": "restaurant"
        ],
        [
          "title": "Ly-Rics",
          "latitude": 33.5351693,
          "longitude": 126.6283361,
          "type": "restaurant"
        ],
        [
          "title": "해오름가든",
          "latitude": 33.5319835,
          "longitude": 126.6265803,
          "type": "restaurant"
        ],
        [
          "title": "청우가든",
          "latitude": 33.5306844,
          "longitude": 126.6259431,
          "type": "restaurant"
        ],
        [
          "title": "신촌풍경",
          "latitude": 33.5316173,
          "longitude": 126.628933,
          "type": "restaurant"
        ],
        [
          "title": "별장가든",
          "latitude": 33.5357333,
          "longitude": 126.6314383,
          "type": "restaurant"
        ],
        [
          "title": "가베또롱",
          "latitude": 33.5348947,
          "longitude": 126.6294292,
          "type": "cafe"
        ],
        [
          "title": "딜레탕트",
          "latitude": 33.5350575,
          "longitude": 126.628334,
          "type": "cafe"
        ],
        [
          "title": "조천리 앞 바다",
          "latitude": 33.5353119,
          "longitude": 126.6290835,
          "type": "nature"
        ]
      ]
    
    private var currentPin: NMFMarker? = nil // 현재 선택된 핀(Marker)
    private var map = NMFMapView()
    private var setNMap = true // 지도가 중복되서 설정되는 것을 방지

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.frame = view.frame
        map.touchDelegate = self
        
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        if setNMap {
            setNMap = false
            setupNMap()
        }
        setCameraMap()
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
        setCameraMap() // MARK: 버튼 작동 여부를 위한 테스트
    }
}

// 지도에 관한 Extention입니다.
extension MapViewController {
    private func setupNMap() {
        setMarkOfficePlace()
        setCameraMap()
    }
    
    /// 카메라를 입력 받은 위도 경도로 이동하는 함수
    private func setCameraMap() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .none
        cameraUpdate.animationDuration = 1
        map.moveCamera(cameraUpdate)
    }
    
    /// 지도 위에 주변 정보 마커 표시하기 위한 함수
    private func setMarkOfficePlace() {
        // 클릭 되었다면 클릭된 마크 표시를 - 클릭이 해제되었다면 클릭 해제된 마크 표시
        let clickedMarker: (NMFOverlay) -> Bool = { [weak self] marker in
            guard let marker = marker as? NMFMarker else { return false }
            let cureentImage = marker.iconImage
            switch marker.tag {
            case Pin.cafe.rawValue: marker.iconImage = NMFOverlayImage(name: "selectedcafepin")
            case Pin.restaurant.rawValue: marker.iconImage = NMFOverlayImage(name: "selectedrestaurantpin")
            case Pin.sea.rawValue: marker.iconImage = NMFOverlayImage(name: "selectedseapin")
            case Pin.nature.rawValue: marker.iconImage = NMFOverlayImage(name: "selectednaturepin")
            default: marker.iconImage = cureentImage
            }
            
            switch self?.currentPin?.tag {
            case Pin.cafe.rawValue: self?.currentPin?.iconImage = NMFOverlayImage(name: "cafepin")
            case Pin.restaurant.rawValue: self?.currentPin?.iconImage = NMFOverlayImage(name: "restaurantpin")
            case Pin.sea.rawValue: self?.currentPin?.iconImage = NMFOverlayImage(name: "seapin")
            case Pin.nature.rawValue: self?.currentPin?.iconImage = NMFOverlayImage(name: "naturepin")
            default: print(self?.currentPin?.tag)
            }
            
            self?.currentPin = marker
            
            return true
        }
        
        nearbyPlaces.forEach { place in
            let marker = NMFMarker()
            
            guard let latitude = place["latitude"] as? Double, let longitude = place["longitude"] as? Double else { return }
            marker.position = NMGLatLng(lat: latitude, lng: longitude)
            
            guard let title = place["title"] as? String else { return }
            marker.captionText = title
            
            marker.touchHandler = clickedMarker
            
            guard let type = place["type"] as? String, let pinImage = UIImage(named: "\(type)pin") else { return }
            marker.iconImage = NMFOverlayImage(image: pinImage)
            
            switch type {
            case "cafe": marker.tag = Pin.cafe.rawValue
            case "nature": marker.tag = Pin.nature.rawValue
            case "sea": marker.tag = Pin.sea.rawValue
            case "restaurant": marker.tag = Pin.restaurant.rawValue
            default: marker.tag = UInt.init(-1)
            }
    
            marker.mapView = map
        }
        
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    // 네이버 지도가 터치 되었을 때에 실행되는 함수
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(point.debugDescription)
    }
    
    // 네이버 지도가 심볼을 터치 했을 때에 실행되는 함수
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol.debugDescription)
        return true
    }
}
