//
//  DetailDataModel.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/26.
//

import Foundation

struct OfficeDetailResource: Codable {
    let content: [OfficeDetail]
}

struct OfficeDetail: Codable {
    let type: String
    let font: String?
    let content: String
    let color: String?
    
    enum CodingKeys: String, CodingKey {
        case type, font, color
        case content = "context"
    }
}
