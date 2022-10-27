//
//  Button+.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/22.
//

import UIKit

extension UIButton {
    func closeButton() -> UIButton {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .theme.primary
        button.backgroundColor = .theme.background
        button.layer.cornerRadius = 22

        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
        
        return button
    }
}
