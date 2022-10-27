//
//  HorizontalCollectionView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

/// 가로 스크롤 컬렉션뷰를 간편하게 만들기 위한 **Custom UICollectionView**
/// - itemSize: 셀의 사이즈
/// - spacing: 줄 간 간격. 가로 스크롤이기에 좌우 간격이라고 생각하면 된다.
/// - inset: 컬렉션뷰의 크기로부터 내부 컨텐츠들의 inset.
final class HorizontalCollectionView: UICollectionView {
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
