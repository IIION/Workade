//
//  MagazineListViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import UIKit

@MainActor
final class MagazineViewModel {
    private var magazines = [MagazineModel]()
    
    var isCompleteFetch = Binder(false)
    
    init() {
        requestMagazineData()
    }
    
    func requestMagazineData() {
        Task {
            do {
                let resource: MagazineResource = try await NetworkManager.shared.requestResourceData(from: Constants.Address.magazineResource)
                magazines = resource.content
                self.setupMagazineModelsBookmark()
                self.isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
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
