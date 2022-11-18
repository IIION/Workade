//
//  FeatureView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/11/18.
//

import UIKit

class FeatureView: UIView {
    
    // TODO: Layout을 잡기 위해 작성되었습니다. office 모델에 특징에 대한 데이터가 포함되고 나면 삭제될 예정입니다.
    let officeFeatureSample: [Features] = [
        Features(featureImage: "cafeTest", featureDescription: "커피가 무료에요"),
        Features(featureImage: "coffeeTest", featureDescription: "카페같은 분위기에요"),
        Features(featureImage: "monitorTest", featureDescription: "모니터를 이용할 수 있어요"),
        Features(featureImage: "motelTest", featureDescription: "숙소가 같이 있어요"),
        Features(featureImage: "reservationTest", featureDescription: "1일 단위로 예약할 수 있어요")
    ]
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        // TODO: Office 모델에 파라미터 추가 후 변경 예정.
        return officeFeatureSample.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeatureCollectionViewCell = collectionView.dequeue(for: indexPath)
        // TODO: Office 모델에 파라미터 추가 후 변경 예정.
        cell.descriptionLabel.text = officeFeatureSample[indexPath.row].featureDescription
        cell.imageView.image = UIImage(named: officeFeatureSample[indexPath.row].featureImage) ?? UIImage()
        return cell
    }
}
