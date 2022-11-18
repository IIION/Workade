//
//  HomeViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

@MainActor
final class HomeViewModel {
    typealias Size = NSCollectionLayoutSize
    private var bookmarkManager = BookmarkManager.shared
    
    private(set) var officeResource = OfficeResource()
    private(set) var magazineResource = MagazineResource()
    
    /// 모델 데이터 fetch가 완료되었을 때, HomeViewController에 알려주는 역할을 할 Binder 타입의 변수
    private(set) var isCompleteFetch = Binder(false)
    
    init() {
        requestHomeData()
        bindingBookmarkManager() // 북마크
    }
    
    private func requestHomeData() {
        Task {
            do {
                async let offices: OfficeResource = NetworkManager.shared.requestResourceData(from: Constants.Address.officeResource)
                async let magazines: MagazineResource = NetworkManager.shared.requestResourceData(from: Constants.Address.magazineResource)
                (officeResource, magazineResource) = try await (offices, magazines)
                isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    // MARK: 북마크 Logic in ViewModel (init시에 bindingBookmarkManager()호출)
    
    /// 눌린 북마크의 id를 cell - viewController - viewModel - bookmarkManager 흐름으로 알립니다.
    private(set) var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        bookmarkManager.clickedMagazineId.bind(at: .home) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    /// ViewController -> ViewModel -> Manager
    func notifyClickedMagazineId(title id: String, key: String) {
        bookmarkManager.notifyClickedMagazineId(title: id, key: key)
    }
    
    deinit {
        BookmarkManager.shared.clickedMagazineId.remove(at: .home)
    }
}

// MARK: GuideHomeView의 전체 레이아웃 관리
extension HomeViewModel {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            // 전달받은 섹션 index별 알맞는 섹션을 생성
            var section: NSCollectionLayoutSection!
            switch sectionIndex {
            case 0:
                section = self.createOfficeSection()
            case 1:
                section = self.createMagazineSection()
            case 2:
                section = self.createCheckListSection()
            default:
                return nil
            }
            
            // 이하 섹션별 공통설정
            section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
            section.interGroupSpacing = 20
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
            // office, magazine 섹션만 헤더를 생성
            if sectionIndex < 2 {
                let headerSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header] // for header
            }
            
            return section
        }
        
        // 이하 전체 컬렉션뷰의 설정
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        config.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
    
    // office section
    private func createOfficeSection() -> NSCollectionLayoutSection {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = Size(widthDimension: .estimated(280), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    // magazine section
    private func createMagazineSection() -> NSCollectionLayoutSection {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = Size(widthDimension: .estimated(130), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    // checkList section
    private func createCheckListSection() -> NSCollectionLayoutSection {
        let itemSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = Size(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        return NSCollectionLayoutSection(group: group)
    }
}
