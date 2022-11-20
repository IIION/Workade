//
//  MagazineListViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import UIKit

@MainActor
final class MagazineViewModel {
    
    var magazineData = MagazineResource()
    var isCompleteFetch = Binder(false)
    
    init() {
        requestMagazineData()
        bindingBookmarkManager()
    }
    
    func requestMagazineData() {
        Task {
            do {
                magazineData = try await NetworkManager.shared.requestResourceData(from: Constants.Address.magazineResource)
                isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        BookmarkManager.shared.clickedMagazineId.bind(at: .detail) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    func notifyClickedMagazineId(title id: String, key: String) {
        BookmarkManager.shared.notifyClickedMagazineId(title: id, key: key)
    }
    
    deinit {
        BookmarkManager.shared.clickedMagazineId.remove(at: .detail)
    }
}

extension MagazineViewModel {
    typealias Size = NSCollectionLayoutSize
    /// create MagazineCollectionView's Compositional Layout
    func createLayout() -> UICollectionViewLayout {
        let itemSize = Size(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(20)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 30, trailing: 20)
        section.interGroupSpacing = 20
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
