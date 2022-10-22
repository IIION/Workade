//
//  TipDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/18.
//

import UIKit

class TipDetailViewController: UIViewController {
    // TODO: 임시 데이터 -> 추후 요청으로 수정
    let titleArray = ["내 성격에 맞는\n장소 찾는 법", "바다마을에서\n보낸 일주일", "워케이션\n경험자의 조언", "워케이션\n경험자의 꿀팁", "워케이션\n경험자의 특별한장소", "워케이션\n센터주변 맛집정보"]
    
    private let tipDetailCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(TipDetailCell.self, forCellWithReuseIdentifier: TipDetailCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipDetailCollectionView.dataSource = self
        tipDetailCollectionView.delegate = self
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(tipDetailCollectionView)
        NSLayoutConstraint.activate([
            tipDetailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tipDetailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tipDetailCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            tipDetailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TipDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (UIScreen.main.bounds.width - 60) / 2, height: 220)
        }
}

extension TipDetailViewController: UICollectionViewDelegate {
    
}

// TODO: 추후 요청으로 처리
extension TipDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TipDetailCell.identifier, for: indexPath) as? TipDetailCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.bookMarkButton.addTarget(self, action: #selector(clickedBookmarkButton(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    // TODO: 추후 데이터 로직과 연결하여 수정
    @objc
    func clickedBookmarkButton(sender: UIButton) {
        if sender.currentImage
            == UIImage(systemName: "bookmark") {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
}
