//
//  CellImageView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/22.
//

import UIKit

class CellImageView: UIImageView {
    init(bounds: CGRect) {
        super.init(frame: .zero) // 추후 Skeleton에 초기 이미지 넣어도 될 듯함
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = 12
        backgroundColor = .theme.groupedBackground // Skeleton color
        
        let path = UIBezierPath(rect: bounds)
        let blackLayer = CAShapeLayer()
        blackLayer.path = path.cgPath
        blackLayer.fillColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.addSublayer(blackLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
