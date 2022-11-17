//
//  MapViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/28.
//

import NMapsMap
import UIKit

struct MapViewModel {
    let latitude: Double
    let longitude: Double
    let officeName: String
    let spots: [Spot]
    var currentMarker: NMFMarker? = nil
    
    init(office: OfficeModel) {
        self.latitude = office.latitude
        self.longitude = office.longitude
        self.officeName = office.officeName
        self.spots = office.spots
    }
    
    func fetchSelectedIcon(_ marker: NMFMarker) -> NMFOverlayImage {
        switch marker.tag {
        case Pin.cafe.rawValue: return NMFOverlayImage(name: "selectedcafepin")
        case Pin.restaurant.rawValue: return NMFOverlayImage(name: "selectedrestaurantpin")
        case Pin.sea.rawValue: return NMFOverlayImage(name: "selectedseapin")
        case Pin.nature.rawValue: return NMFOverlayImage(name: "selectednaturepin")
        default: return marker.iconImage
        }
    }
    
    func fetchUnselectedIcon(_ marker: NMFMarker) -> NMFOverlayImage {
        switch marker.tag {
        case Pin.cafe.rawValue: return NMFOverlayImage(name: "cafepin")
        case Pin.restaurant.rawValue: return NMFOverlayImage(name: "restaurantpin")
        case Pin.sea.rawValue: return NMFOverlayImage(name: "seapin")
        case Pin.nature.rawValue: return NMFOverlayImage(name: "naturepin")
        default: return marker.iconImage
        }
    }
}
