//
//  OfficeViewModel.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/20.
//

import UIKit

@MainActor
final class OfficeViewModel {
    
}

extension OfficeViewModel {
    typealias Size = NSCollectionLayoutSize
    func createLayout() -> UICollectionViewLayout {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.51))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 30, trailing: 20)
        section.interGroupSpacing = 20
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
