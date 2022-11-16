//
//  GalleryResource.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/15.
//

import UIKit

struct GalleryResource: Codable {
    let items: [GalleryImageModel]
    
    init() {
        self.items = []
    }
    
    enum CodingKeys: String, CodingKey {
        case items = "content"
    }
}

struct GalleryImageModel: Codable {
    let content: String
}
