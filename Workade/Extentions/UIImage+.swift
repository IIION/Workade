//
//  UIImage+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/18.
//

import UIKit

extension UIImage {
    convenience init?(symbolName: String, font: UIFont, color: UIColor = .black) {
        let configuration = UIImage.SymbolConfiguration(font: font)
        self.init(systemName: symbolName, withConfiguration: configuration)
        self.withTintColor(color)
    }
    
    func setOriginal() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
