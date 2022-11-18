//
//  CheckListNavigationCell.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/18.
//

import UIKit

class CheckListNavigationCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "checklist"
        label.font = .customFont(for: .headline)
        
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
