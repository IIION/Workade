//
//  ChecklistTemplateViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import Foundation
import UIKit

class CheckListTemplateViewModel {
    var image: UIImage = UIImage(named: "folder") ?? UIImage()
    var title: String = "개발자라면 필수로\n챙겨야 할 물건 리스트"
    var color: UIColor = .systemYellow
    var partialText: String = "개발자"
    var checklist: [String] = []
}
