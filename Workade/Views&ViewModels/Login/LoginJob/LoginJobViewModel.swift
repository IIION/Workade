//
//  LoginJobViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/24.
//

import UIKit

struct LoginJobViewModel {
    var name: String?
    var selectedJob: Job? = nil
    var isPickerOpened = false
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
}

enum DefaultPickerImage {
    case chevronDown
    case chevronUp
    
    var image: UIImage? {
        switch self {
        case .chevronDown: return UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default))
        case .chevronUp: return UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default))
        }
    }
}
