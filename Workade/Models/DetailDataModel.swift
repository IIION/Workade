//
//  DetailDataModel.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/26.
//

import Foundation

struct DetailDataModel: Codable {
    let content: [Content]
}

struct Content: Codable {
    let font: String?
    let type: String
    let context: String
    let color: String?
}
