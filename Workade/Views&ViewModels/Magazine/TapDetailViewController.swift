//
//  TipDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/18.
//

import UIKit

class TapDetailViewController: UIViewController {
    var magazineList: [Magazine] = []
    
    let tapDetailCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(cell: MagazineCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    init(magazineList: [Magazine]) {
        super.init(nibName: nil, bundle: nil)
        self.magazineList = magazineList
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapDetailCollectionView.dataSource = self
        tapDetailCollectionView.delegate = self
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(tapDetailCollectionView)
        NSLayoutConstraint.activate([
            tapDetailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tapDetailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tapDetailCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            tapDetailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TapDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 60) / 2
        
        return CGSize(width: width, height: width * 1.3)
    }
}

extension TapDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellItemDetailViewController = CellItemDetailViewController(label: self.magazineList[indexPath.row].title)
        
        cellItemDetailViewController.modalPresentationStyle = .overFullScreen
        present(cellItemDetailViewController, animated: true)
    }
}

// TODO: 추후 요청으로 처리
extension TapDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return magazineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
        cell.configure(magazine: magazineList[indexPath.row])
        return cell
    }
    
    // TODO: 추후 데이터 로직과 연결하여 수정
    @objc
    func clickedBookmarkButton(sender: UIButton) {
        var image: UIImage?
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
        
        if sender.currentImage == UIImage(systemName: "bookmark", withConfiguration: config) {
            image = UIImage(systemName: "bookmark.fill", withConfiguration: config)
            sender.setImage(image, for: .normal)
        } else {
            image = UIImage(systemName: "bookmark", withConfiguration: config)
            sender.setImage(image, for: .normal)
        }
    }
}
