//
//  TempGalleryView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/20.
//

import UIKit

class GalleryView: UIView {
    private var bottomSafeArea: CGFloat {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return CGFloat(44) }
        guard let window = scene.windows.first else { return CGFloat(44) }
        return window.safeAreaInsets.top
    }
    let layout = UICollectionViewTwoLineLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GalleryCollectionViewCell.self,
                                forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupLayout() {
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomSafeArea - 20)
        ])
    }
}
