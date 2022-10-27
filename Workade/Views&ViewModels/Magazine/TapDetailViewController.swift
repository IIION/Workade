//
//  TipDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/18.
//

import UIKit

class TapDetailViewController: UIViewController {
    // TODO: 임시 데이터 -> 추후 요청으로 수정
    let titleArray = ["내 성격에 맞는\n장소 찾는 법", "바다마을에서\n보낸 일주일", "워케이션\n경험자의 조언", "워케이션\n경험자의 꿀팁", "워케이션\n경험자의 특별한장소", "워케이션\n센터주변 맛집정보"]
    
    let tapDetailCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(TapDetailCell.self, forCellWithReuseIdentifier: TapDetailCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
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
        let cellItemDetailViewController = CellItemDetailViewController(label: self.titleArray[indexPath.row])
        
        cellItemDetailViewController.modalPresentationStyle = .overFullScreen
        present(cellItemDetailViewController, animated: true)
    }
}

// TODO: 추후 요청으로 처리
extension TapDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapDetailCell.identifier, for: indexPath) as? TapDetailCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.bookMarkButton.addTarget(self, action: #selector(clickedBookmarkButton(sender:)), for: .touchUpInside)
        
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
