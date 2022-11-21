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
    
    private func requestMagazineData() {
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
    /// filter and return data for diffableDataSource's snapshot
    func filteredMagazine(category: MagazineCategory) -> [MagazineModel] {
        guard isCompleteFetch.value else { return [] }
        switch category {
        case .total:
            return magazines
        case .wishList:
            return magazines.filter { $0.isBookmark }
        default:
            return magazines.filter { $0.category == category }
        }
    }
    
    typealias Size = NSCollectionLayoutSize
    /// create MagazineCollectionView's Compositional Layout
    func createLayout() -> UICollectionViewLayout {
        let itemSize = Size(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.63))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MagazineViewModel {
    /// 북마크값 세팅. 추후 서버관리로직으로 변경될 부분.
    func setupMagazineModelsBookmark() {
        let wishList = UserDefaultsManager.shared.loadUserDefaults(key: Constants.Key.wishMagazine)
        magazines.enumerated().forEach({ index, magazine in
            if wishList.contains(magazine.title) {
                magazines[index].isBookmark = true
            } else {
                magazines[index].isBookmark = false
            }
        })
    }
}
