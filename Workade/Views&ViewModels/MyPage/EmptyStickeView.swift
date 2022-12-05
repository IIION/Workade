//
//  EmptyStickeView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/12/05.
//

import UIKit

class EmptyStickeView: UIView {
    private let emptyStickerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "blank"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let emptyStickerLabel: UILabel = {
        let label = UILabel()
        label.text = "워케이션을 해서 스티커를 획득하세요!"
        label.font = .customFont(for: .captionHeadline)
        label.textColor = .theme.primary
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(emptyStickerImageView)
        NSLayoutConstraint.activate([
            emptyStickerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStickerImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(emptyStickerLabel)
        NSLayoutConstraint.activate([
            emptyStickerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStickerLabel.topAnchor.constraint(equalTo: emptyStickerImageView.bottomAnchor, constant: 20)
        ])
    }
}
