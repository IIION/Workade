//
//  UIImage+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/18.
//

import UIKit

extension UIImage {
    static func fromSystemImage(name: String, font: UIFont, color: UIColor = .black) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: name, withConfiguration: configuration)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }

    func setOriginal() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}

enum SFSymbol {
    case info
    case mapInCell
    case chevronLeft // in navigationbar
    case chevronRight

    var image: UIImage {
        switch self {
        case .info:
            return .fromSystemImage(name: "info.circle.fill", font: .customFont(for: .headline), color: .theme.primary)!
        case .mapInCell:
            return .fromSystemImage(name: "map", font: .systemFont(ofSize: 16, weight: .bold), color: .white)!
        case .chevronLeft:
            return .fromSystemImage(name: "chevron.left", font: .customFont(for: .headline), color: .theme.primary)!
        case .chevronRight:
            return .fromSystemImage(name: "chevron.right", font: .systemFont(ofSize: 15, weight: .heavy), color: .theme.primary)!
        }
    }
}
