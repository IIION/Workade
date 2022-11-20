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
    var categories = ["전체", "팁", "칼럼", "후기", "찜한 리스트"]
    
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
    /// filter and return data for diffableDataSource's snapshot
    func filteredMagazine(category: MagazineCategory) -> [MagazineModel] {
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
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(20)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 30, trailing: 20)
        section.interGroupSpacing = 20
        
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
