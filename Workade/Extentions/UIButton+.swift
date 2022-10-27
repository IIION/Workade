//
//  Button+.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/22.
//

import UIKit

extension UIButton {
    func setCloseButton() -> UIButton {
        let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .medium, scale: .default)

        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .theme.background

        return button
    }
}
