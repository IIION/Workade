//
//  TempGalleryView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/20.
//

import UIKit

class GalleryView: UIView {
    
    var bottomSafeArea = CGFloat(44)
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
        setupBottomSafeArea()
        setupLayout()
//        viewModel.fetchImages()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupBottomSafeArea() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = scene.windows.first else { return }
        bottomSafeArea = window.safeAreaInsets.top
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
