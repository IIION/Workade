//
//  StickerView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/16.
//

import UIKit

class StickerView: UIView {
    private lazy var stickerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: StickerCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(stickerCollectionView)
        NSLayoutConstraint.activate([
            stickerCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            stickerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stickerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            stickerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: FlowLayout
extension StickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 30 * 4) / 3
        
        // Figma 상의 비율로 보면 width 90 , height 142 이기 때문에 이를 나눈 비율로 각 셀의 높이를 계산
        return CGSize(width: width, height: width * 1.57)
    }
}

// MARK: CollectionView Delegate
extension StickerView: UICollectionViewDelegate {
    
}

// MARK: CollectionView DataSource
extension StickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: 유저의 스티커 갯수에 따라 리턴
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StickerCollectionViewCell = collectionView.dequeue(for: indexPath)
        // TODO: 유저의 스티커 내용을 리턴
        
        return cell
    }
}
