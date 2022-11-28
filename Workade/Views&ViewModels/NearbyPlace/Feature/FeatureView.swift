//
//  FeatureView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/11/18.
//

import UIKit

class FeatureView: UIView {
    var officeFeatures: [Feature]
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // 셀 사이의 간격.
        flowLayout.minimumLineSpacing = 10
        // 스크롤 방향
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cell: FeatureCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    init(officeFeature: [Feature]) {
        self.officeFeatures = officeFeature
        super.init(frame: .zero)
        
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.bottomSafeArea - 20)
        ])
    }
}

extension FeatureView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width - 40 - 10) / 2
        
        return CGSize(width: cellWidth, height: 104)
    }
}

extension FeatureView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return officeFeatures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeatureCollectionViewCell = collectionView.dequeue(for: indexPath)
        
        cell.descriptionLabel.text = officeFeatures[indexPath.row].featureDescription
        cell.imageView.image = UIImage(named: officeFeatures[indexPath.row].featureImage) ?? UIImage()
        
        return cell
    }
}
