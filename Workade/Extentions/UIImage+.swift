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
