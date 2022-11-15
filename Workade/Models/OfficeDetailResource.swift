//
//  OfficeDetailResource.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/26.
//

import Foundation

struct OfficeDetailResource: Codable {
    let content: [OfficeDetailModel]
    
    init() {
        self.content = []
    }
}

struct OfficeDetailModel: Codable {
    let type: String
    let font: String?
    let content: String
    let color: String?
}
