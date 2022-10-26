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
    var title: String = ""
    var color: UIColor = .theme.primary
    var partialText: String = ""
    var checklist: [String] = []
}
