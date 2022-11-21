//
//  OfficeResource.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

struct OfficeResource: Codable {
    let content: [OfficeModel]
    
    init() {
        self.content = []
    }
}

struct OfficeModel: Codable, Hashable {
    let uuid = UUID()
    let officeName: String
    let regionName: String
    let imageURL: String
    let introduceURL: String
    let galleryURL: String
    let latitude: Double
    let longitude: Double
    let spots: [Spot]
    
    enum CodingKeys: String, CodingKey {
        case officeName = "officename"
        case regionName = "regionname"
        case imageURL = "imageurl"
        case introduceURL = "introduceurl"
        case galleryURL = "galleryurl"
        case latitude, longitude, spots
    }
    
    // uuid를 해시값으로 삼겠다고 명시. (uuid 안쓰면, 다른 프로퍼티 중에서 알아서 기준값 잡아줌 <- 중복 위험있음)
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Spot: Codable, Hashable {
    let title: String
    let latitude: Double
    let longitude: Double
    let type: String
    
    var spotType: SpotType {
        switch self.type {
        case "cafe":
            return .cafe
        case "nature":
            return .nature
        case "restaurant":
            return .restaurant
        default:
            return .cafe
        }
    }
}

enum SpotType: String {
    case cafe
    case nature
    case restaurant
    case sea
}

struct Feature: Codable {
    let featureImage: String
    let featureDescription: String
}
