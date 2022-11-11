//
//  MagazineModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import Foundation

// Magazine 상세 뷰 모델
struct MagazineDetailResource: Codable {
    let content: [MagazineDetail]
    
    init() {
        self.content = []
    }
}

// MagazineDetailModel 모델
struct MagazineDetail: Codable {
    let type: String
    let font: String?
    let content: String
    let color: String?
    
    enum CodingKeys: String, CodingKey {
        case type, font, color
        case content = "context"
    }
}
