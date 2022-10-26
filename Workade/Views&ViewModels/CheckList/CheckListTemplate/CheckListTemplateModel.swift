//
//  CheckListTemplate.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import Foundation
import UIKit

struct CheckListTemplateModel {
    var id: Int = 0
    var image: UIImage
    var title: String
    var color: UIColor
    var partialText: String
    var checklist: [String]
}

extension CheckListTemplateModel {
    static let sample = CheckListTemplateModel(id: 0,
                                          image: UIImage(named: "folder") ?? UIImage(),
                                          title: "개발자라면 필수로\n챙겨야 할 물건 리스트",
                                          color: .systemYellow,
                                          partialText: "개발자",
                                          checklist: [])
}
