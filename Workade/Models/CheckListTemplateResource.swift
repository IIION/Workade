//
//  CheckListTemplateResource.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import UIKit

struct CheckListTemplateResource: Codable {
    let content: [CheckListTemplateModel]
    
    init() {
        self.content = []
    }
}

struct CheckListTemplateModel: Codable {
    let imageURL: String
    let title: String
    let tintColor: String
    let tintString: String
    let list: [String]
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imageurl"
        case title, tintColor, tintString, list
    }
}
