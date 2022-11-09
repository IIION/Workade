//
//  GradientView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/06.

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) has not been implemented")
    }
    
    func configure() {}
    func bind() {}
}

class GradientView: BaseView {
    
    var gradientLayerColors: [UIColor]? {
        didSet { bind() }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override func configure() {
        super.configure()
        
        layer.addSublayer(gradientLayer)
        isUserInteractionEnabled = false
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.0)
        gradientLayer.frame = bounds
    }
    
    override func bind() {
        super.bind()
        
        gradientLayer.colors = gradientLayerColors?.compactMap { $0.cgColor }
    }
}

// 참고 : https://github.com/JK0369/GradientViewSample/blob/master/Component/GradientView/BaseView.swift
