//
//  TipDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/18.
//

import UIKit

class TapDetailViewController: UIViewController {
    let viewModel = MagazineViewModel()
        
    lazy var tapDetailCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: MagazineCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        observingFetchComplete()
        observingChangedMagazineId()
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
        let magazine = viewModel.magazineData.magazineContent[indexPath.row]
        let cellItemDetailViewController = CellItemDetailViewController(magazine: magazine)
        
        cellItemDetailViewController.modalPresentationStyle = .fullScreen
        self.view.window?.rootViewController?.present(cellItemDetailViewController, animated: true)
    }
}

extension TapDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.magazineData.magazineContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MagazineCollectionViewCell = collectionView.dequeue(for: indexPath)
        cell.delegate = self
        cell.configure(magazine: viewModel.magazineData.magazineContent[indexPath.row])
        
        return cell
    }
}

extension TapDetailViewController: CollectionViewCellDelegate {
    func didTapBookmarkButton(id: String) {
        viewModel.notifyClickedMagazineId(title: id, key: Constants.wishMagazine)
    }
}

extension TapDetailViewController {
    private func observingFetchComplete() {
        viewModel.isCompleteFetch.bindAndFire { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tapDetailCollectionView.reloadData()
            }
        }
    }
    
    private func observingChangedMagazineId() {
        viewModel.clickedMagazineId.bindAndFire { [weak self] id in
            guard
                let self = self,
                let index = self.viewModel.magazineData.magazineContent.firstIndex(where: { $0.title == id })
            else { return }
            
            DispatchQueue.main.async {
                self.tapDetailCollectionView.reloadItems(at: [.init(item: index, section: 0)])
            }
        }
    }
}
