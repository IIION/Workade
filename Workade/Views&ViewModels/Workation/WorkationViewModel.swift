//
//  WorkationViewModel.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/17.
//

import CoreLocation
import Foundation

final class WorkationViewModel: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    let address = CLGeocoder.init()
    
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
                print("description : \(place[0].description)")
                print("country : \(place[0].country ?? "")")
                print("administrativeArea : \(place[0].administrativeArea ?? "")")
                print("locality : \(place[0].locality ?? "")")
                print("subLocality : \(place[0].subLocality ?? "")")
                print("thoroughfare : \(place[0].thoroughfare ?? "")")
                print("subThoroughfare : \(place[0].subThoroughfare ?? "")")
                print("name : \(place[0].name ?? "")")
                print("postalCode : \(place[0].postalCode ?? "" )")
            }
        }
    }
}
