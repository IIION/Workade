//
//  FeatureCollectionViewCell.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/11/18.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {
    // 이미지
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // 설명
    let subscribeLabel: UILabel = {
        let subscribeLabel = UILabel()
        subscribeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return subscribeLabel
    }()
    
    lazy var cell: UIView = {
        let cell = UIView()
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .rgb(0xF7F7FA)
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        return cell
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(cell)
        
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell.topAnchor.constraint(equalTo: topAnchor),
            cell.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
