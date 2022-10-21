//
//  HorizontalCollectionView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

class HorizontalCollectionView: UICollectionView {
    init(itemSize: CGSize, spacing: CGFloat = 20, inset: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .horizontal
        layout.sectionInset = inset
        self.collectionViewLayout = layout
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
