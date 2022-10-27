//
//  MagazineModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import Foundation
// MagazineDetailModel 모델
struct MagazineDetailModel: Codable {
    let type: String
    let font: String?
    let context: String
    let color: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case font
        case context
        case color
    }
}

// Magazine 상세 뷰 모델
struct MagazineDataModel: Codable {
    let magazineData: [MagazineDetailModel]
    
    enum CodingKeys: String, CodingKey {
        case magazineData = "content"
    }
}

struct MagazineItemModel: Codable {
    let context: String
    
    enum CodingKeys: String, CodingKey {
        case context
    }
}
