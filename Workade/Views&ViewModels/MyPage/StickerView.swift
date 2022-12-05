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
        let stickerCollectionViewCell = StickerCollectionViewCell()
        let width = (UIScreen.main.bounds.width - 30 * 4) / 3
        
        return CGSize(width: width, height: stickerCollectionViewCell.getContainerHeight())
    }
}

// MARK: CollectionView Delegate
extension StickerView: UICollectionViewDelegate {
    
}

// MARK: CollectionView DataSource
extension StickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let stickersArray = UserManager.shared.user.value?.stickers else { return 0 }
        
        return stickersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StickerCollectionViewCell = collectionView.dequeue(for: indexPath)
        guard let stickersArray = UserManager.shared.user.value?.stickers else { return cell }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        cell.stickerNameLabel.text = stickersArray[indexPath.row].title.name
        cell.stickerImage.image = UIImage(named: stickersArray[indexPath.row].title.rawValue)
        cell.stickerLocationLabel.text = "\(stickersArray[indexPath.row].region.name)에서 획득"
        cell.stickerDataLabel.text = dateFormatter.string(from: stickersArray[indexPath.row].date)
        
        return cell
    }
}
