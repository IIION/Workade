//
//  MapViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/28.
//

import UIKit

struct MapViewModel {
    let latitude: Double
    let longitude: Double
    let officeName: String
    let spots: [Spot]
    
    init(office: Office) {
        self.latitude = office.latitude
        self.longitude = office.longitude
        self.officeName = office.officeName
        self.spots = office.spots
    }
}
