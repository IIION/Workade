//
//  HorizontalCollectionView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

class HorizontalCollectionView: UICollectionView {
    convenience init(itemSize: CGSize, spacing: CGFloat = 20,
                     inset: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .horizontal
        layout.sectionInset = inset
        self.collectionViewLayout = layout
        self.showsHorizontalScrollIndicator = false
    }
}
