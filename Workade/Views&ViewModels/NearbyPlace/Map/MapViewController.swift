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
    private lazy var markerInfoView = MapInfoView()
    private var map = NMFMapView()
    
    init(office: OfficeModel) {
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

        setupNMap()
        setupLayout()
    }
    // 이제는 호출 안하는 함수
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setMapCamera()
    }
    
    private func setupLayout() {
        view.addSubview(map)

        view.addSubview(markerInfoView)
        markerInfoView.isHidden = true
        NSLayoutConstraint.activate([
            markerInfoView.heightAnchor.constraint(equalToConstant: 80),
            markerInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10 - .bottomSafeArea),
            markerInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            markerInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// 지도에 관한 Extention입니다.
extension MapViewController {
    private func setupNMap() {
        setMarkOfficePlace()
        // 필요없는듯?
        setMapCamera()
    }
    
    /// 카메라를 입력 받은 위도 경도로 이동하는 함수
    func setMapCamera() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: viewModel.latitude, lng: viewModel.longitude))
        cameraUpdate.animation = .none
        cameraUpdate.animationDuration = 1
        map.moveCamera(cameraUpdate)
    }
    
    /// 지도 위에 주변 정보 마커 표시하기 위한 함수
    private func setMarkOfficePlace() {
        // 클릭 되었다면 클릭된 마크 표시를 - 클릭이 해제되었다면 클릭 해제된 마크 표시
        let clickedMarker: (NMFOverlay) -> Bool = { [weak self] marker in
            guard let marker = marker as? NMFMarker, let self = self else { return false }
            marker.iconImage = self.viewModel.fetchSelectedIcon(marker)
            if let pin = self.viewModel.currentMarker {
                self.viewModel.currentMarker?.iconImage = self.viewModel.fetchUnselectedIcon(pin)
            }
            
            self.viewModel.currentMarker = (self.viewModel.currentMarker == marker) ? nil : marker
            self.markerInfoView.isHidden = (self.viewModel.currentMarker == nil)
            self.markerInfoView.setMarkerInfo(marker: marker)
            
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
        // 좌표에 대한 정보 출력
        print(point.debugDescription)
    }
    
    // 네이버 지도가 심볼을 터치 했을 때에 실행되는 함수
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol.debugDescription)
        return true
    }
}
