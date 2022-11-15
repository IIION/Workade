//
//  MagazineResource.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/15.
//

import Foundation

struct MagazineResource: Codable {
    let content: [MagazineModel]
    
    init() {
        self.content = []
    }
}

struct MagazineModel: Codable {
    let title: String
    let imageURL: String
    let introduceURL: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "imageurl"
        case introduceURL = "introduceurl"
    }
}
