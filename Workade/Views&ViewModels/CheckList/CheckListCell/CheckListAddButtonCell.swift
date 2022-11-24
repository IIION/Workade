//
//  CheckListAddButtonCell.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/22.
//

import UIKit

class CheckListAddButtonCell: UICollectionViewCell {
    private lazy var addImage: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .theme.workadeBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.theme.workadeBackgroundBlue.cgColor
        contentView.backgroundColor = .theme.background
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckListAddButtonCell {
    private func setupLayout() {
        contentView.addSubview(addImage)
        
        let guide = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            addImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            addImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
    }
}
