//
//  WorkationViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/17.
//

import Combine
import CoreLocation
import Foundation

final class WorkationViewModel: NSObject, CLLocationManagerDelegate {
    
    @Published var subLocality: String?
    @Published var throughfare: String?

    private var locationManager: CLLocationManager!
    private let address = CLGeocoder.init()
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coor = manager.location?.coordinate else { return }
        address.reverseGeocodeLocation(CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)) { (places, error) in
            if error == nil {
                guard let place = places else { return }
                self.subLocality = place[0].subLocality
                self.throughfare = place[0].thoroughfare
            }
        }
    }
}
