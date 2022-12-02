//
//  StickerCollectionViewCell.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/17.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {
    /// 화면 기기너비에 비례한 Image 너비를 계산
    private let stickerImageWidth = (UIScreen.main.bounds.width - 30 * 4) / 3
    
    private let stickerContainerView: UIView = {
        let stickerContainerView = UIView()
        stickerContainerView.backgroundColor = .theme.groupedBackground
        stickerContainerView.layer.cornerRadius = 16
        stickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        return stickerContainerView
    }()
    
    let stickerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let stickerNameLabel: UILabel = {
        let stickerNameLabel = UILabel()
        stickerNameLabel.font = .customFont(for: .footnote2)
        stickerNameLabel.sizeToFit()
        stickerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return stickerNameLabel
    }()
    
    let stickerDataLabel: UILabel = {
        let stickerDataLabel = UILabel()
        stickerDataLabel.font = .customFont(for: .tag)
        stickerDataLabel.sizeToFit()
        stickerDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return stickerDataLabel
    }()
    
    let stickerLocationLabel: UILabel = {
        let stickerLocationLabel = UILabel()
        stickerLocationLabel.font = .customFont(for: .tag)
        stickerLocationLabel.sizeToFit()
        stickerLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return stickerLocationLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(stickerContainerView)
        NSLayoutConstraint.activate([
            stickerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stickerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stickerContainerView.widthAnchor.constraint(equalToConstant: stickerImageWidth),
            stickerContainerView.heightAnchor.constraint(equalTo: widthAnchor)
        ])
        
        stickerContainerView.addSubview(stickerImage)
        NSLayoutConstraint.activate([
            stickerImage.centerXAnchor.constraint(equalTo: stickerContainerView.centerXAnchor),
            stickerImage.centerYAnchor.constraint(equalTo: stickerContainerView.centerYAnchor)
        ])
        
        addSubview(stickerNameLabel)
        NSLayoutConstraint.activate([
            stickerNameLabel.topAnchor.constraint(equalTo: stickerContainerView.bottomAnchor, constant: 6),
            stickerNameLabel.leadingAnchor.constraint(equalTo: stickerContainerView.leadingAnchor)
        ])
        
        addSubview(stickerDataLabel)
        NSLayoutConstraint.activate([
            stickerDataLabel.topAnchor.constraint(equalTo: stickerNameLabel.bottomAnchor),
            stickerDataLabel.leadingAnchor.constraint(equalTo: stickerContainerView.leadingAnchor)
        ])
        
        addSubview(stickerLocationLabel)
        NSLayoutConstraint.activate([
            stickerLocationLabel.topAnchor.constraint(equalTo: stickerDataLabel.bottomAnchor),
            stickerLocationLabel.leadingAnchor.constraint(equalTo: stickerContainerView.leadingAnchor)
        ])
    }
    
    /// 이미지와 라벨 사이 간격 6 + 라벨들의 높이 + 스티커 이미지의 동적 너비 ( stickerImageWidth )
    func getContainerHeight() -> Double {
        let nameLabelHeight = stickerNameLabel.bounds.size.height
        let dataLabelHeight = stickerDataLabel.bounds.size.height
        let locationLabelHeight = stickerLocationLabel.bounds.size.height
        
        let labelsHeight = nameLabelHeight + dataLabelHeight + locationLabelHeight
        
        return labelsHeight + 6 + stickerImageWidth
    }
}
