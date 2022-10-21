//
//  UICollectionView+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/20.
//

import UIKit

// MARK: Cell 등록을 간편하게 하기위한 확장
extension UICollectionView {
    
    // before: register(SomeCollectionViewCell.self, forCellWithReuseIdentifier: SomeCollectionViewCell.identifier)
    // after: register(cell: SomeCollectionViewCell.self)
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    /* before: let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:SomeCollectionViewCell.identifier, for: indexPath)
            as! SomeCollectionViewCell
       after: let cell = SomeCollectionViewCell = collectionView.dequeue(for: indexPath) */
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.identifier,
            for: indexPath) as? T else { return T() }
        
        return cell
    }
}

// ref. https://nemecek.be/blog/82/useful-extensions-for-collectionview-and-compositional-layout
