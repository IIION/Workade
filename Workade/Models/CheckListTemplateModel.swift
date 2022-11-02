//
//  CheckListTemplate.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import UIKit

struct CheckListTemplateResource: Codable {
    let context: [CheckListTemplateModel]
}

struct CheckListTemplateModel: Codable {
    let imageURL: String
    let title: String
    let tintColor: String
    let tintString: String
    let listURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imageurl"
        case listURL = "listurl"
        case title, tintColor, tintString
    }
}
