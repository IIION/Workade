//
//  MapViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/23.
//

import NMapsMap
import UIKit

class MapViewController: UIViewController {
    private var viewModel: MapViewModel
    
    private var currentPin: NMFMarker? = nil {
        willSet(newVal) {
            if newVal == nil {
                naverMapButton.isHidden = true
            } else {
                naverMapButton.isHidden = false
            }
        }
    }
    
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
        label.text = viewModel.officeName
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
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var naverMapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("네이버 맵으로 바로가기", for: .normal)
        button.titleLabel?.font = .customFont(for: .title2)
        button.layer.backgroundColor = CGColor(red: 94/255, green: 204/255, blue: 105/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(naverButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    init(office: Office) {
        viewModel = MapViewModel(office: office)
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
        
        view.addSubview(naverMapButton)
        NSLayoutConstraint.activate([
            naverMapButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            naverMapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            naverMapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            naverMapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        naverMapButton.isHidden = true
        
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
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
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
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: viewModel.latitude, lng: viewModel.longitude))
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
            default: break
            }
            
            if self?.currentPin != marker {
                self?.currentPin = marker
            } else {
                self?.currentPin = nil
            }
            
            return true
        }
        
        for spot in viewModel.spots {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: spot.latitude, lng: spot.longitude)
            marker.captionText = spot.title
            
            marker.touchHandler = clickedMarker
            
            guard let pinImage = UIImage(named: "\(spot.spotType.rawValue)pin") else { return }
            marker.iconImage = NMFOverlayImage(image: pinImage)
            
            switch spot.spotType {
            case .cafe: marker.tag = Pin.cafe.rawValue
            case .nature: marker.tag = Pin.nature.rawValue
            case .sea: marker.tag = Pin.sea.rawValue
            case .restaurant: marker.tag = Pin.restaurant.rawValue
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

extension MapViewController {
    @objc private func naverButtonTapped() {
        guard let title = currentPin?.captionText else { return }
        let urlStr = "nmap://search?query=\(title)"
        guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedStr)
        else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
