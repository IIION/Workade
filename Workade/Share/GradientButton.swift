//
//  GradientButton.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/11/20.
//

import UIKit

class GradientButton: UIButton {
    
    var layerCornerRadius: CGFloat = 20

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let subLayer = CAGradientLayer()
        subLayer.frame = self.bounds
        subLayer.colors = [
            UIColor(red: 0.098, green: 0.518, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.098, green: 0.134, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.098, green: 0.351, blue: 1, alpha: 1).cgColor
        ]
        subLayer.startPoint = CGPoint(x: 0.75, y: 0.25)
        subLayer.endPoint = CGPoint(x: 0.25, y: 0.75)
        subLayer.cornerRadius = layerCornerRadius
        layer.insertSublayer(subLayer, at: 0)
        
        return subLayer
    }()
}
