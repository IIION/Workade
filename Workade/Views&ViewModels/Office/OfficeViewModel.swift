//
//  OfficeViewModel.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/11/20.
//

import UIKit

@MainActor
final class OfficeViewModel {
    private var officeResource = OfficeResource()
    let regions = ["전체", "제주", "양양", "고성", "경주", "포항"] // 추후 서버데이터로부터 구성할 것 생각.
    
    var isCompleteFetch = Binder(false)
    
    init() {
        requestOfficeData()
    }
    
    private func requestOfficeData() {
        Task {
            do {
                officeResource = try await NetworkManager.shared.requestResourceData(from: Constants.Address.officeResource)
                self.isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
}

extension OfficeViewModel {
    /// filter and return data for diffableDataSource's snapshot
    func filteredOffice(region: String) -> [OfficeModel] {
        guard isCompleteFetch.value else { return [] }
        // 아직 서버에는 '제주도' <- 이렇게 되있어서 우선 contains를 사용.
        return region == "전체" ? officeResource.content : officeResource.content.filter { $0.regionName.contains(region) }
    }
    
    typealias Size = NSCollectionLayoutSize
    /// create OfficeCollectionView's Compositional Layout
    func createLayout() -> UICollectionViewLayout {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.51))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 30, trailing: 20)
        section.interGroupSpacing = 20
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
