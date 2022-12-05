//
//  CAGradientLayer+.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/18.
//

import UIKit

extension CAGradientLayer {
    static let workadeBlueGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.rgb(0x1984FF).cgColor, UIColor.rgb(0x1922FF).cgColor, UIColor.rgb(0x1959FF).cgColor]
        gradient.startPoint = .init(x: 1, y: 0)
        gradient.endPoint = .init(x: 0, y: 1)
        
        return gradient
    }()
}
