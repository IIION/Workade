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
    
    private let stickerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: 스티커로 변경 예정
        image.image = UIImage(named: "sampleSticker")
        
        return image
    }()
    
    private let stickerNameLabel: UILabel = {
        let stickerNameLabel = UILabel()
        // TODO: footnote2 2차 디자인 시스템 적용
        stickerNameLabel.font = .customFont(for: .footnote)
        // TODO: Data 연결시 삭제
        stickerNameLabel.text = "감귤 스티커"
        stickerNameLabel.sizeToFit()
        stickerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return stickerNameLabel
    }()
    
    private let stickerDataLabel: UILabel = {
        let stickerDataLabel = UILabel()
        // TODO: footnote2 2차 디자인 시스템 적용
        stickerDataLabel.font = .customFont(for: .caption)
        // TODO: Data 연결시 삭제
        stickerDataLabel.text = "2022.12.03"
        stickerDataLabel.sizeToFit()
        stickerDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return stickerDataLabel
    }()
    
    private let stickerLocationLabel: UILabel = {
        let stickerLocationLabel = UILabel()
        // TODO: footnote2 2차 디자인 시스템 적용
        stickerLocationLabel.font = .customFont(for: .caption)
        // TODO: Data 연결시 삭제
        stickerLocationLabel.text = "제주에서 획득"
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
