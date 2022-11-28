//
//  UIVIew+.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/21.
//

import UIKit

extension UIView {
    func setGradient(_ colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = self.bounds
        layer.insertSublayer(gradient, at: 0)
    }
}
