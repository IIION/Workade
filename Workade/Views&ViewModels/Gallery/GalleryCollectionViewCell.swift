//
//  GalleryCollectionViewCell.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/20.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GalleryCollectionViewCell"
    
    lazy var image: UIImage? = {
        let image = UIImage(named: "")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .theme.groupedBackground
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
